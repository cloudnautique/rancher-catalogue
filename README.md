# Rancher Catalog

In Rancher, one of the two automatically packaged catalogs is this repository and the [community-catalog](https://github.com/rancher/community-catalog). 

## Branches

If you are running Rancher v1.6.1+, the **library** catalog points to a git mirror of the **v1.6-release** branch of this repo.

If you are running Rancher v1.6.0 and lower,  the **library** catalog points to a git mirror of the **v1.6-release** branch of this repo.

### Branches before a Release

When developing and testing new templates, a new dev branch for the upcoming release is created and packaged in our `rancher/server:master` container. For example, when we are developing and testing for `v1.6.0`, a `v1.6.0-dev` branch is created. Any PRs with changes should be made to this **dev** branch.

Each Rancher RC is packaged with a specific branch to isolate what specific versions of templates were tested. The RC branch are created from the current **dev** branch at the time of cutting the RC. If there are fixes that need to be made to address the templates, they should always be made to the **dev** branch. QA will pick up the **dev** branch for their RCs, if there are known issues in the specific branch packaged for the RC.

> **Note:** Branches for specific RCs may be deleted in the future, as Rancher does not maintain the RCs.

Before an official Rancher release is created, a PR will be made to bring all changes from the **dev** branch to the **master** branch. The commits will be squashed into the 1 commit.

### Branches after a Release

After the **dev** branch of a release has been merged to **master** and Rancher has been released, the first patch release will have  a branch created based on **master**. All following RCs for the patch release would be based on the previous RC until the patch release was completed. And then the cycle would start again. 

> **Example:** Rancher releases v1.5.0. If Rancher is starting to test for Rancher v1.5.1, the first RC branch will be made from **master**, which would be **v1.5.1-rc1**. Any changes for the releases would be made into this branch. For the next RC, a new branch (i.e. **v1.5.1-rc2**) will be created from **v1.5.1-rc1**. This would continue until we release Rancher, where the last RC branch for the patch release would be merged into the **master** branch. While the v1.5.1 RCs are being created, there would be a **v1.6.0-dev** branch, which would contain changes for Rancher v1.6.0.  

## Template Versions

When making changes to a template into an existing catalog, compare the current **dev** branch with the **master** branch to see if a new folder needs to be created.

1. Check to see if a new folder is needed in the **dev** branch. We are trying to maintain only **1** new template for each release as it will be the new default version for Rancher. 
      1. If the folders are the same in the **dev** and **master** branch are the same, then a new folder will need to be created. This new folder is created to add in the new template changes that are being introduced in the latest version of Rancher. 
          1. Create a base copy of the latest default.
          2. Determine what the current default version of the catalog is. **IT IS NOT GUARANTEED TO BE THE LATEST FOLDER.** Go to the `config.yml` of the template to find the version number. Find the corresponding template folder that has this version.
> **Example of Folder Alignment:** Folder `0` contains version `v0.1.0` for Rancher 1.1. Folder `1` contains version `v0.2.0` for Rancher 1.2, but this template is not compatible with Rancher 1.1. A fix needs to be made for Rancher 1.1, so a new folder `2` is created and contains version `v0.1.2` which is for Rancher 1.1, but will not be the default version for Rancher 1.2. 
          3. Copy the folder and commit the change as `Base copy of folder X`
      2. If there is already new folder in the **dev** branch that is not in the **master** branch, use the new folder in the **dev** branch. All changes for a template would go in the **same** folder during a release cycle. Upgrade testing will always be done from the previous Rancher version, which would contain a template in a different folder.

2. Make changes to the template.

3. Update the version of the template in the `rancher-compose.yml`
  a. When introducing a new folder, the minor version should be increased. If the previous version was `v0.3.1`, it should now be `v0.4.0`.
  b. When using an existing folder in the **dev** branch, which would occur only after a new folder had been introduced for that release cycle, the patch version should be increased. If the current version in the new folder is `v0.4.0`, then it should be `v0.4.1`.

> **Example:** We made a change in the scheduler. There is no new difference in folders for **master** and **dev**, so we introduced folder `2`. The previous version of the template was `v0.2.0`, so the new version `v0.3.0` is for the new folder. During testing, more changes needed to be made to scheduler. Since we are still in the same Rancher release, we would continue to re-use folder `2`. The next template version with changes would be `v0.3.1`.   

4. If the version will be the latest default in the upcoming release, update the version in the `config.yml`

## Rancher Versions

When creating new templates of a catalog, please review the `minimum_rancher_version:` in the `rancher-compose.yml` to confirm that it's accurate. Due to resourcing, Rancher is generally only able to test out 1 version of a infrastructure service for a release. Therefore, the new folder should have a `minimum_rancher_version` of the release that it is being introduced for. Also, any old templates should be reviewed and a `maximum_rancher_version` of the previous release should be used.

> **Example:** We are working on Rancher v1.6 on the **v1.6.0-dev** branch. When introducing any new folders/versions templates, we should update the `minimum_rancher_version` to be `v1.6.0-rc1`. In any old folder, we should add in `maximum_rancher_version` and set it at `v1.5.99` to indicate those versions are only for the `v1.5.X` release. 

## Contact
For bugs, questions, comments, corrections, suggestions, etc., open an issue in
 [rancher/rancher](//github.com/rancher/rancher/issues) with a title starting with `[rancher-catalog] `.

Or just [click here](//github.com/rancher/rancher/issues/new?title=%5Brancher-catalog%5D%20) to create a new issue.

# License
Copyright (c) 2014-2015 [Rancher Labs, Inc.](http://rancher.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
