import { loadStdlib } from '@reach-sh/stdlib';
import * as backend from './build/index.main.mjs';
const stdlib = loadStdlib(process.env);

// constants
const budget = 10;
const suStr = stdlib.standardUnit
const OUTCOME = ['Alice Wins!', 'Bob Wins!',"Draw"]


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
  budget: parseCurrency(budget),
  deadline: 10,
  acceptBudget: async (amount) => {
    // if (Math.random() <= 0.5) {
    //   for (let i = 0; i < 10; i++) {
    //     console.log(`  Bob takes his sweet time...`);
    //     await stdlib.wait(1);
    //   }
    // } else {
    console.log(`\n ${who} accepted the budget of ${formatCurrency(amount)} ${suStr} \n`);
    // }
  },
  getSquareSelected: async (state) => {
    const board = state.board;
    // console.log(`\n ${who} chooses a move from the state:\n  ${createBoard(state)} \n`)
    while (board) {
      // if (Math.random() <= 0.5) {
      //   for (let i = 0; i < 10; i++) {
      //     console.log(`${who} takes his sweet time...`);
      //     await stdlib.wait(1);
      //   }
      // } else {
        const randomNumber = Math.floor(Math.random() * 9)
        const isSquaredFilled = board[randomNumber] == 'x' || board[randomNumber] == 'o'
        if (!isSquaredFilled) {
          return randomNumber;
        // }
      }




    }
    throw Error(`impossibe to make a move`)
    // if(board[randomNumber]){
    //   return randomNumber;
    // }
  },
  seeOutcome: (outcome) => {
    console.log(`\n ${who} saw an outcome of ${OUTCOME[outcome]} \n`);
  },
  seeBoard: (state) => {
    console.log(`\n ${who} chooses a move from the state:\n  ${createBoard(state)} \n`)
  },
  endsWith: (state) => {
    console.log(`${who} sees the final state \n ${createBoard(state)} `)
  },
  informTimeOut: () => {
    console.log(`${who} observes a time out`)
  }
})

const startingBalance = stdlib.parseCurrency(100);

const [accAlice, accBob] =
  await stdlib.newTestAccounts(2, startingBalance);

// Alice and Bob initial balance
const getBalance = async (who) => formatCurrency(await stdlib.balanceOf(who));
const beforeAlice = await getBalance(accAlice);
const beforeBob = await getBalance(accBob);
console.log('Hello, Alice and Bob!');

console.log('Launching...');
const ctcAlice = accAlice.contract(backend);
const ctcBob = accBob.contract(backend, ctcAlice.getInfo());

console.log('Starting backends...');
await Promise.all([
  backend.Alice(ctcAlice, interactwith("Alice")),
  backend.Bob(ctcBob, interactwith("Bob")),
]);

const afterAlice = await getBalance(accAlice)
const afterBob = await getBalance(accBob)

console.log(`Alice went from ${beforeAlice} to ${afterAlice}`)
console.log(`Bob went from ${beforeBob} to ${afterBob}`)
