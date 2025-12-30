const js = require("@eslint/js");
const globals = require("globals");

module.exports = [
    js.configs.recommended,
    {
        languageOptions: {
            globals: {
                ...globals.node
            }
        }
    },
    {
        files: ["public/**/*.js"],
        languageOptions: {
            globals: {
                ...globals.browser
            }
        }
    },
    {
        files: ["**/__tests__/**/*.js", "**/*.test.js"],
        languageOptions: {
            globals: {
                ...globals.jest
            }
        }
    }
];
