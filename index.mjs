import { loadStdlib } from '@reach-sh/stdlib';
import * as backend from './build/index.main.mjs';
const stdlib = loadStdlib(process.env);

// constants
const budget = 10;
const suStr = stdlib.standardUnit
const OUTCOME = ['Alice Wins!', 'Bob Wins!',]


// helper functions
const createBoard = (state) => {
  let board = `\n`
  for (let i = 0; i < 9; i++) {
    board += state.board[i] === "x" ? "X" : state.board[i] === "o" ? "O" : " ";
    if (i != 8) {
      board += (i % 3 == 2) ? "\n-----\n" : "|"
    }
  }
  return board;
}

const parseCurrency = (amount) => stdlib.parseCurrency(amount);
const formatCurrency = (amount) => stdlib.formatCurrency(amount, 4);


const interactwith = (who) => ({
  ...stdlib.hasRandom,
  getBudget: () => {
    console.log(`${who}'s budget for the game is ${formatCurrency(parseCurrency(budget))} ${suStr}`);
    return parseCurrency(budget);
  },
  acceptBudget: (amount) => {
    console.log(`${who} accepted the budget of ${formatCurrency(amount)} ${suStr}`);
  },
  getSquareSelected: (state) => {
    console.log(`${who} chooses a move from the state:\n  ${createBoard(state)} \n`)
    const board = state.board;
    while (board) {
      const randomNumber = Math.floor(Math.random() * 9)
      const isSquaredFilled = board[randomNumber] == 'x' || board[randomNumber] == 'o'
      if (!isSquaredFilled) {
        return randomNumber;
      }
    }
    throw Error(`impossibe to make a move`)
    // if(board[randomNumber]){
    //   return randomNumber;
    // }
  },
})

const startingBalance = stdlib.parseCurrency(100);

const [accAlice, accBob] =
  await stdlib.newTestAccounts(2, startingBalance);
console.log('Hello, Alice and Bob!');

console.log('Launching...');
const ctcAlice = accAlice.contract(backend);
const ctcBob = accBob.contract(backend, ctcAlice.getInfo());

console.log('Starting backends...');
await Promise.all([
  backend.Alice(ctcAlice, interactwith("Alice")),
  backend.Bob(ctcBob, interactwith("Bob")),
]);

console.log('Goodbye, Alice and Bob!');
