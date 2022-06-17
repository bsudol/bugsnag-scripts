Bugsnag.start({
  apiKey: 'your_api_key',
  plugins: [new BugsnagPluginReact(React)],

  onError: function (event) {
    // Amend event information

    // Simple logic to get redux state - you may need to parse this
    // and pull out relevant parts of this information before adding to Bugsnag metadata
    const state = store.getState();

    event.addMetadata('redux', 
      {
        reduxState: state
      }
    )
  }
})