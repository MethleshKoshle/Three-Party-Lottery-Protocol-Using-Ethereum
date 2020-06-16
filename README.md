# Three-Party-Lottery-Protocol-Using-Ethereum
This project implements TPLP using Ethereum (Blockchain), written in solidity
Description of functions used:
## 1. Constructor
  * Some user say(user_1) press deploy button, along with the value of initial money each user will have.
  * Each user gets initial account balance=V(entered in deploy).
  * This user is the owner or starter of the lottery.

## 2. getRandomLotteryTicket
 * This function returns a random number between [1, 1000]

## 3. init_user
 * This function assigns the calling user to one of the users user_1, user_2 and user_3

## 4. buyTicketUser(price)
 * Using this function each user buys a lottery ticket by paying the price(10$).
 * Each user pays price for the ticket

## 5. send_A_B(amount)
 * Using this function user A sends 'amount' money to the user B.

## 6. getBalU
 * Using this function each user checks his current account balance.

## 7. getNumberU
 * Using this function each user checks his lottery number, allotted to her/him.

## 8. getWinnerRandomly
 * This function returns a random number from lottery numbers{L1, L2, L3}.

## 9. startLottery
 * Owner starts the lottery.
 * Calculates the hash of the winner's lottery number.

## 10. checU(lottery number)
 * Using this function a user checks if his/lottery number equals to the winner's lottery number or not.

## 11. endTheLottery
 * The owner of the lottery calls this function to check if the winner of the lottery was found successfully.
 * Otherwise the lottery ticket price is refunded to the users.
