const { env } = require('../configuration.js')

module.exports = {
    enforce: 'pre',
    test: /\.(js|jsx|vue)$/i,
    exclude: /node_modules/,
    loader: 'eslint-loader',
    options: {
        failOnError: env.NODE_ENV !== 'production'
    }
}
