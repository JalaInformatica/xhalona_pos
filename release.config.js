module.exports = {
  branches: ['main'],
  plugins: [
    '@semantic-release/commit-analyzer',
    '@semantic-release/release-notes-generator',
    '@semantic-release/git',
    {
      path: '@semantic-release/exec',
      cmd: 'sed -i "s/version: .*/version: ${nextRelease.version}/" pubspec.yaml || echo "Failed to update version in pubspec.yaml"',
    },
  ],
};