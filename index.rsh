'reach 0.1';

const SQAURES = 9;
const BOARD = Array(Bytes(1), SQAURES)

const STATE = Object({
  playerTurn: Bool,
  board: BOARD,
})
const board = Array.replicate(9, " ")


const errIsMoveInBoard = "A square in the board should be selected"
const errIsMoveValid = "The square has been played by a player already"

const initialGameState = (player) => ({
  playerTurn: player,
  board,
})

// // check winning combo in row
// const row = (b, r) => {
//   const n = r * 3;
//   const p1 = b[n]; 
//   const p2 = b[n + 1];
//   const p3 = b[n + 2];
//   if (p1 == p2 && p1 == p3) {
//     return p1
//   } else {
//     return '-'
//   }

// }

// // check winning combo in col
// const col = (b, c) => {
//   const p1 = b[c]; 
//   const p2 = b[c + 3];
//   const p3 = b[c + 6];
//   if (p1 == p2 && p1 == p3) {
//     return p1
//   } else {
//     return '-'
//   }
// }

// // diagonal starting at the column 0 and row 0
// const diagonalLeft = (b, c) => {
//   const p1 = b[0]; 
//   const p2 = b[4];
//   const p3 = b[8];
//   if (p1 == p2 && p1 == p3) {
//     return p1;
//   } else {
//     return '-'
//   }
// }

// // diagonal starting at the column 2 and row 0
// const diagonalRight = (b, c) => {
//   const p1 = b[2]; 
//   const p2 = b[4];
//   const p3 = b[6];
//   if (p2 == p2 && p2 == p3) {
//     return p1
//   } else {
//     return '-'
//   }
// }

const checkWin = (b) => {

  const [p0, p1, p2, p3, p4, p5, p6, p7, p8] = [...b];

  const row1 = p0 == p1 && p0 == p2 ? p0 : '-'
  const row2 = p3 == p4 && p3 == p5 ? p3 : '-'
  const row3 = p6 == p7 && p6 == p8 ? p6 : '-'

  const col1 = p0 == p3 && p0 == p6 ? p0 : '-'
  const col2 = p1 == p4 && p1 == p7 ? p1 : '-'
  const col3 = p2 == p5 && p2 == p8 ? p2 : '-'

  const leftDiagonal = p0 == p4 && p0 == p8 ? p0 : '-'
  const rightDiagonal = p2 == p4 && p2 == p6 ? p2 : '-'

  if(row1 == 'x' || row2 == 'x' || row3 == 'x' || col1 == 'x' || col2 == 'x' || col3 == 'x' || leftDiagonal == 'x' || rightDiagonal == 'x') {
    return 0
  }
  else {
    if(row1 == 'o' || row2 == 'o' || row3 == 'o' || col1 == 'o' || col2 == 'o' || col3 == 'o' || leftDiagonal == 'o' || rightDiagonal == 'o'){
      return 1
    }else {
      return 2
    }
  }
}

// const xWon = (b) => {
//   const row1 = row(b, 0)
//   const row2 = row(b, 1)
//   const row3 = row(b, 2)

//   const col1 = col(b, 0)
//   const col2 = col(b, 1)
//   const col3 = col(b, 2)

//   const leftDiagonal = diagonalLeft(b, 0)
//   const rightDiagonal = diagonalRight(b, 2)

//   return row1 == 'x' || row2 == 'x' || row3 == 'x' ||
//   col1 == 'x' || col2 == 'x' || col3 == 'x' ||
//   leftDiagonal == 'x' || rightDiagonal == 'x'
// }

// const oWon = (b) => {

//   const row1 = row(b, 0)
//   const row2 = row(b, 1)
//   const row3 = row(b, 2)

//   const col1 = col(b, 0)
//   const col2 = col(b, 1)
//   const col3 = col(b, 2)

//   const leftDiagonal = diagonalLeft(b, 0)
//   const rightDiagonal = diagonalRight(b, 2)

//   return row1 == 'o' || row2 == 'o' || row3 == 'o' ||
//   col1 == 'o' || col2 == 'o' || col3 == 'o' ||
//   leftDiagonal == 'o' || rightDiagonal == 'o'
// }

// const calculateWinner = (b) => (xWon(b) ? 0 : oWon(b) ? 1 : 2)

// helper function

// check if the move is not outside the board
const isMoveInBoard = (move) => (0 <= move && move < SQAURES)


// check if the squared has been selected by a player
const isMoveValid = (state, move) => {
  const p1 = state.board[move];
  return !(p1 == "x" || p1 == "o")
}


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
    playerTurn: !player,
    board: (player ? state.board.set(move, "x") : state.board.set(move, "o"))
  }
}

const isAllSquaresFilled = (state) => Array.all(state.board, (square) => (square === 'x' || square === 'o')) // All squares filled

const hasGameEnd = (state) => {
  const winStatus = checkWin(state.board)
  return isAllSquaresFilled(state) || winStatus == 1 || winStatus == 0
}


const commonInteract = {
  ...hasRandom,
  getSquareSelected: Fun([STATE], UInt),
  seeBoard: Fun([STATE], Null),
  seeOutcome: Fun([UInt], Null),
  endsWith: Fun([STATE], Null),
  informTimeOut: Fun([], Null),
  deadline: UInt,
}

const AInteract = {
  ...commonInteract,
  budget: UInt,
}

const BInteract = {
  ...commonInteract,
  acceptBudget: Fun([UInt], Null)
}

export const main = Reach.App(() => {
  const A = Participant('Alice', AInteract);
  const B = Participant('Bob', BInteract);
  init();


  const informTimeOut = () => {
    each([A, B], () => {
      interact.informTimeOut();
    });
  }
  // The first one to publish deploys the contract
  A.only(() => {
    const budget = declassify(interact.budget);
    const deadline = declassify(interact.deadline);
  });
  A.publish(budget, deadline)
    .pay(budget);
  commit();

  // The second one to publish always attaches
  B.interact.acceptBudget(budget);
  B.pay(budget).timeout(relativeTime(deadline), () => closeTo(A, informTimeOut));
  // commit();

  var state = initialGameState(true)
  invariant(balance() == (2 * budget))
  while (!hasGameEnd(state)) {
    if (state.playerTurn == true) {
      commit()

      A.only(() => {
        const xMove = getValidSquare(interact, state)
      });
      A.publish(xMove)
        .timeout(relativeTime(deadline), () => closeTo(B, informTimeOut));
      A.interact.seeBoard(applyPlayerMove(state, xMove))
      state = applyPlayerMove(state, xMove);

      continue;
    } else {
      commit()

      B.only(() => {
        const oMove = getValidSquare(interact, state)
      });

      B.publish(oMove)
        .timeout(relativeTime(deadline), () => closeTo(A, informTimeOut));
      B.interact.seeBoard(applyPlayerMove(state, oMove))
      state = applyPlayerMove(state, oMove);
      // B.interact.seeBoard(state)
      continue;

    }
  }
  const outcome = checkWin(state.board)
  const [toA, toB] = outcome == 0? [2, 0] : outcome == 1? [0, 2]: [1, 1];
  // const [toA, toB] = (xWon(state.board))
  // const [toA, toB] = (xWon(state.board) ? [2, 0] : oWon(state.board) ? [0, 2] : [1, 1])


  transfer(toA * budget).to(A)
  transfer(toB * budget).to(B)
  // transfer(balance()).to(A)
  commit();

  each([A, B], () => {
    interact.endsWith(state);
    interact.seeOutcome(outcome);
  })
  // write your program here
  exit();
});