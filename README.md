# cloud_carbon_footprint

Make sure there is no yarn.lock file in user's home directory or at the location you are installing the app.

    npx @cloud-carbon-footprint/create-app@latest

Named app as ccf-aabg

    cd ccf-aabg

This will guide you with required permission for IAM role, required services and data source to fetch the details etc
  
    yarn guided-install

  ![Configuration it will ask for](./images/ccf-config.png)

  And start the app

    yarn start

  You can just run yarm install if you don't want it to configure with AWS data yet.

    yarn install

  start the app

    # if you are using yarn start instead of yarn guided-install
    yarn start-with-mock-data
