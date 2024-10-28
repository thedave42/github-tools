import 'dotenv/config'
import fs from 'fs';
import { Octokit } from 'octokit';
import { createAppAuth } from '@octokit/auth-app';
import pkg from 'enquirer';
const MultiSelect = pkg.MultiSelect;



const PRIVATE_KEY = fs.readFileSync(process.env.PRIVATE_KEY_PATH, 'utf8');

const octokit = new Octokit({
  authStrategy: createAppAuth,
  auth: {
    appId: process.env.APP_ID,
    privateKey: PRIVATE_KEY,
    installationId: process.env.INSTALLATION_ID,
  },
});


try {
  const {
    data: { slug },
  } = await octokit.rest.apps.getAuthenticated();
  
  console.log(`Application ${slug} is authenticated.`);
  console.log(`Organization ${process.env.ORG_SLUG} is being queried.`);

  const response = await octokit.request('GET /orgs/{org}/credential-authorizations', {
    org: process.env.ORG_SLUG,
    headers: {
      'X-GitHub-Api-Version': '2022-11-28'
    }
  });

  if (response.data !== undefined && response.data.length > 0) {
    console.log(response.data.length);
    const choices = response.data.map((item) => {
      return {
        name: item.credential_id,
        message: item.credential_id,
        value: item.credential_id,
        hint: `Type: ${item.credential_type}\tLogin: ${item.login}\tScopes: ${item.scopes}\n\t\tAuthorized note: ${item.authorized_credential_note}\n\t\tAuthorized at: ${item.credential_authorized_at}\n\t\tAccessed at: ${item.credential_accessed_at}\n\t\tExpires at: ${item.authorized_credential_expires_at}`
      }
    });

    const prompt = new MultiSelect({
      name: 'credentials',
      message: 'Select credentials to delete',
      choices: choices,
      result(names) {
        return this.map(names);
      }
    });

    const credentials = await prompt.run();

    console.log(credentials)

    //const deleteResponse = await octokit.request('DELETE /orgs/{org}/credential-authorizations/{credential_id}', {
    //  org: process.env.ORG_SLUG,
    //  credential_id: credentials,
    //  headers: {
    //    'X-GitHub-Api-Version': '2022-11-28'
    //  }
    //});

    //console.log(deleteResponse);
  }
  else {
    console.log("No credentials found.");
  }
}
catch (error) {
  console.log(error.message);
}
