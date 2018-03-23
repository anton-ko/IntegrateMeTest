module.exports = {
  "plugins": ['vue'],
  "env": {
      "browser": true
  },
  "extends": ["airbnb-base", 'plugin:vue/essential'],
  "rules": {
    "max-len": [2, {"code": 120}],
    'import/extensions' : 'off',
    "import/no-unresolved": 'off', // todo: figure out why it doesn't resolve components properly
  }
};
