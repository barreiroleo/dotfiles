# Contributing as maintainer

The ez way is to clone their repo, make changes, and push to the branch.
I don't want to do that, I just want to get pr in a work-tree, work and send a normal push.

# Instructions to contribute changes from a forked repository branch:

1. Add the forked repository as a remote:
   ```sh
   git remote add johndoe-fork https://github.com/johndoe/nvim-config.git
   ```

2. Fetch branches from the fork:
   ```sh
   git fetch johndoe-fork
   ```

3. Create and switch to a new branch tracking the fork's pr branch:
   ```sh
   git checkout -b johndoe-pr --track johndoe-fork/johndoe-pr-branch
   ```

4. Make your changes and commit them:
   ```sh
   echo "still testing" >> README.md
   git add README.md
   git commit -m "More things"
   ```

5. Push your changes to the fork's pr branch:
   ```sh
   git push johndoe-fork HEAD:johndoe-pr-branch
   ```

6. Clean up local branches and remotes:
   ```sh
   # Switch back to master
   git checkout master
   # Delete the local feature branch
   git branch -D johndoe-pr
   # Remove the fork remote
   git remote remove johndoe-fork
   ```
