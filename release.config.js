module.exports = {
  branches: ['main'],
  plugins: [
    '@semantic-release/commit-analyzer',
    '@semantic-release/release-notes-generator',
    {
      path: '@semantic-release/exec',
      cmd: 'sed -i "s/version: .*/version: ${nextRelease.version}/" pubspec.yaml',
    },
    '@semantic-release/git',
  ],
};