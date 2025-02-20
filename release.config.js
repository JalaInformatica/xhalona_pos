module.exports = {
  branches: ['main'],
  plugins: [
    '@semantic-release/commit-analyzer',
    '@semantic-release/release-notes-generator',
    '@semantic-release/git',
    {
      // Plugin untuk memperbarui pubspec.yaml
      path: '@semantic-release/exec',
      cmd: 'sed -i "s/version: .*/version: ${nextRelease.version}/" pubspec.yaml',
    },
  ],
};