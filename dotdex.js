const { spawn } = require('child_process');
const fs = require('fs');

const args = process.argv.slice(2);
const dotdex = fs.readFileSync('./dotdex');

function pull () {
  const { repo } = dotdex;
  console.log(repo);
}

function push () {
  const { repo } = dotdex;
  console.log(repo);
}

switch (args[0]) {
  case 'pull':
    pull();
    break;
  case 'push':
    push();
    break;
  default:
}
