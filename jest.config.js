module.exports = {
  setupFilesAfterEnv: [ '<rootDir>/setupTests.js' ],
  testMatch: [ '**/__tests__/**/*.js?(x)', '**/?(*.)+(spec|test).js?(x)', "<rootDir>/spec/javascript/**/*.{js,jsx}" ],
  moduleNameMapper: {
    '\\.module\\.(css|sass|scss)$': 'identity-obj-proxy',
  },
  testEnvironment: 'jsdom',
  testEnvironmentOptions: {
    html: '<html lang="zh-cmn-Hant"></html>',
    url: 'https://jestjs.io/',
    userAgent: 'Agent/007',
  },
  testPathIgnorePatterns: [ "/node_modules/", "config/webpack/test.js" ]
}
