const { graphql } = require("@octokit/graphql");

const token = "";
const owner = "thedave42-org";
const templateRepo = "javascript-ghas-demo";
const newRepoName = "new-template-repo";

let query = `
query {
  organization(login: "${owner}") {
    id
    repository(name: "${templateRepo}") {
      id
    }
  }
}
`;

graphql(query, { headers: { authorization: `token ${token}` } })
  .then(data => 
    {
      query = `
      mutation($input: CloneTemplateRepositoryInput!) {
        cloneTemplateRepository(input: $input) {
          repository {
            name
          }
        }
      }
    `;
    
    const variables = {
      input: {
        repositoryId: data.organization.repository.id,
        ownerId: data.organization.id,
        name: newRepoName,
        visibility: "INTERNAL"
      }
    };
    
    return graphql(query, { ...variables, headers: { authorization: `token ${token}` } })
      .then(data => console.log(`Created new repository: ${data.cloneTemplateRepository.repository.name}`))
      .catch(error => console.error(error));
  })
  .catch(error => console.error(error));
