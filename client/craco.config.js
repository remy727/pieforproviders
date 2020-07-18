const CracoLessPlugin = require('craco-less')

module.exports = {
  plugins: [
    {
      plugin: CracoLessPlugin,
      options: {
        lessLoaderOptions: {
          lessOptions: {
            modifyVars: {
              '@primary-color': '#006C9E',
              '@font-family': 'Proxima Nova'
            },
            javascriptEnabled: true
          }
        }
      }
    }
  ]
}
