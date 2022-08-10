'reach 0.1';

const SQAURES = 9;
const BOARD = Array(Bytes(1), SQAURES)

const STATE = Object({
  playerTurn: Bool,
  board: BOARD,
})
// const board = Array.replicate(9,'')
const board = Array.replicate(9, " ")

const winningPatterns = [
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [2, 4, 6]
]

const errIsMoveInBoard = "A square in the board should be selected"
const errIsMoveValid = "The square has been played by a player already"

const initialGameState = (player) => ({
  playerTurn: player,
  board,
})

// helper function

// check if the move is not outside the board
const isMoveInBoard = (move) => (0 <= move && move < SQAURES)


// check if the squared has been selected by a player
const isMoveValid = (state, move) => (! (state.board[move] == "x" || state.board[move] == "o"))


const getValidSquare = (interact, state) => {
  const _move = interact.getSquareSelected(state)
  assume(isMoveInBoard(_move), errIsMoveInBoard)
  assume(isMoveValid(state, _move), errIsMoveValid)
  return declassify(_move)
}

const applyPlayerMove = (state, move) => {
  require(isMoveInBoard(move), errIsMoveInBoard)
  require(isMoveValid(state, move), errIsMoveValid)
  const player = state.playerTurn
  return {
    playerTurn: ! player,
    board: (player ? state.board.set(move, "x") : state.board.set(move, "o"))
  }
}

const isAllSquaresFilled = (state) => Array.all(state.board, (square) => (square === 'x' || square === 'o')) // All squares filled
// const checkWin = (state) => {
//   pattern.forEach((currentPattern) =>{
//     const firstPlayer = state.board[currentPattern[0]]
//     if(firstPlayer == "") return;
//     let foundWinngingPattern = true
//     currentPattern.forEachWithIndex((dummy, index) => {
//       if (state.board[index] !== firstPlayer){
//         foundWinngingPattern = false;
//       }
//     })
//     return currentPattern 
//   })
// }

const hasGameEnd = (state) => (isAllSquaresFilled(state))
// || (checkWin(state))

const commonInteract = {
  ...hasRandom,
  getSquareSelected: Fun([STATE], UInt)

}

const AInteract = {
  ...commonInteract,
  getBudget: Fun([], UInt)
}

const BInteract = {
  ...commonInteract,
  acceptBudget: Fun([UInt], Null)
}

export const main = Reach.App(() => {
  const A = Participant('Alice', AInteract);
  const B = Participant('Bob', BInteract);
  init();
  // The first one to publish deploys the contract
  A.only(() => {
    const budget = declassify(interact.getBudget());
  });
  A.publish(budget)
    .pay(budget);
  commit();

  // The second one to publish always attaches
  B.interact.acceptBudget(budget);
  B.pay(budget);
  // commit();

  var state = initialGameState(true)
  invariant(balance() == (2 * budget))
  while (!hasGameEnd(state)) {
    if (state.playerTurn == true) {
      commit()

      A.only(() => {
        const xMove = getValidSquare(interact, state)
      });
      A.publish(xMove);

      state = applyPlayerMove(state, xMove);
      continue;
    } else {
      commit()

      B.only(() => {
        const oMove = getValidSquare(interact, state)
      });

      B.publish(oMove);
      state = applyPlayerMove(state, oMove);
      continue;
    }
  }


  transfer(balance()).to(A)
  commit();
  // write your program here
  exit();
});
