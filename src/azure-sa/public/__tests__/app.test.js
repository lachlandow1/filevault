/**
 * @jest-environment jsdom
 */

const fs = require('fs');
const path = require('path');

const appJsContent = fs.readFileSync(path.resolve(__dirname, '../app.js'), 'utf8');

describe('FileVault App', () => {
    /** @type {jest.Mock} */
    let fetchMock;

    beforeEach(() => {
        document.body.innerHTML = `
            <header>
                <h1>FileVault</h1>
                <label class="switch">
                    <input type="checkbox" id="themeToggle">
                    <span class="slider round"></span>
                </label>
            </header>
            <main>
                <form id="noteForm">
                    <input type="text" id="note" placeholder="Enter file name..." required>
                    <br>
                    <input type="file" id="fileInput" required>
                    <br>
                    <button type="submit">Submit</button>
                </form>
                <div id="notesList"></div>
            </main>
        `;

        fetchMock = jest.fn().mockResolvedValue({
            ok: true,
            json: async () => []
        });
        global.fetch = fetchMock;

        global.alert = jest.fn();
        
        const localStorageMock = (function() {
            let store = {};
            return {
                getItem: function(key) {
                    return store[key] || null;
                },
                setItem: function(key, value) {
                    store[key] = value.toString();
                },
                clear: function() {
                    store = {};
                },
                removeItem: function(key) {
                    delete store[key];
                }
            };
        })();
        Object.defineProperty(window, 'localStorage', { value: localStorageMock, configurable: true });

        this.listeners = [];
        const originalAddEventListener = document.addEventListener;
        document.addEventListener = (event, cb) => {
            this.listeners.push({ event, cb });
            originalAddEventListener.call(document, event, cb);
        };

        eval(appJsContent);
    });

    afterEach(() => {
        if (this.listeners) {
            this.listeners.forEach(({ event, cb }) => {
                document.removeEventListener(event, cb);
            });
        }
        
        jest.restoreAllMocks();
        document.body.innerHTML = '';
        jest.clearAllMocks();
    });

    test('should load files on startup', async () => {
        const mockFiles = [
            { name: 'Test File 1', key: 'key1' },
            { name: 'Test File 2', key: 'key2' }
        ];

        fetchMock.mockResolvedValueOnce({
            ok: true,
            json: async () => mockFiles
        });

        document.dispatchEvent(new Event('DOMContentLoaded'));

        await new Promise(resolve => setTimeout(resolve, 0));

        const notesList = document.getElementById('notesList');
        const rows = notesList.querySelectorAll('tbody tr');
        expect(rows.length).toBe(2);
        expect(rows[0].cells[0].textContent).toBe('Test File 1');
    });

    test('should handle file upload', async () => {
        fetchMock.mockResolvedValueOnce({
            ok: true
        });
        
        fetchMock.mockResolvedValueOnce({
            ok: true,
            json: async () => []
        });

        const noteInput = document.getElementById('note');
        const fileInput = document.getElementById('fileInput');
        
        const file = new File(['dummy content'], 'test.txt', { type: 'text/plain' });

        Object.defineProperty(fileInput, 'files', {
            value: [file],
            configurable: true
        });

        noteInput.value = 'My Test File';

        const form = document.getElementById('noteForm');
        form.dispatchEvent(new Event('submit'));

        await new Promise(resolve => setTimeout(resolve, 0));

        expect(fetchMock).toHaveBeenCalledWith('/upload', expect.objectContaining({
            method: 'POST',
            body: expect.any(FormData)
        }));
        expect(global.alert).toHaveBeenCalledWith('File uploaded successfully!');
        expect(noteInput.value).toBe('');
    });

    test('should validate input before upload', async () => {
        const form = document.getElementById('noteForm');
        
        document.getElementById('note').value = '';
        const file = new File([''], 'test.txt');
        Object.defineProperty(document.getElementById('fileInput'), 'files', { 
            value: [file],
            configurable: true 
        });

        form.dispatchEvent(new Event('submit'));
        expect(global.alert).toHaveBeenCalledWith('Please enter a name for the file.');

        document.getElementById('note').value = 'Some Note';
        Object.defineProperty(document.getElementById('fileInput'), 'files', { 
            value: [],
            configurable: true,
            writable: true
        });

        form.dispatchEvent(new Event('submit'));
        expect(global.alert).toHaveBeenCalledWith('Please select a file to upload.');
    });

    const flushPromises = () => new Promise(resolve => setTimeout(resolve, 0));

    test('should delete a file', async () => {
        const mockFiles = [{ name: 'To Delete', key: 'del-key' }];
        fetchMock.mockResolvedValueOnce({
            ok: true,
            json: async () => mockFiles
        });

        document.dispatchEvent(new Event('DOMContentLoaded'));
        await flushPromises();

        if (document.querySelectorAll('.delete-btn').length === 0) {
            throw new Error('No delete buttons found after initial load');
        }

        fetchMock.mockResolvedValueOnce({
            ok: true
        });
        
        const deleteBtn = document.querySelector('.delete-btn');
        if (!deleteBtn) throw new Error('Delete button not found');
        
        deleteBtn.click();

        await flushPromises();

        expect(fetchMock).toHaveBeenCalledWith('/files/del-key', expect.objectContaining({
            method: 'DELETE'
        }));
        expect(global.alert).toHaveBeenCalledWith('File deleted successfully!');
    });

    test('should toggle theme', () => {
        const themeToggle = document.getElementById('themeToggle');
        
        expect(document.documentElement.getAttribute('data-theme')).toBe('light');

        themeToggle.checked = true;
        themeToggle.dispatchEvent(new Event('change'));
        expect(document.documentElement.getAttribute('data-theme')).toBe('dark');
        expect(window.localStorage.getItem('theme')).toBe('dark');

        themeToggle.checked = false;
        themeToggle.dispatchEvent(new Event('change'));
        expect(document.documentElement.getAttribute('data-theme')).toBe('light');
    });
});
