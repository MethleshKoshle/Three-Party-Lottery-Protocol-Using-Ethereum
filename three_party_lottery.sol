pragma solidity ^0.5.17;

/*
    Three party lottery protocol.
    Methlesh Koshle
*/

contract three_party_lottery{
    // Store the hash of winner's lottery number, when lottery is done.
    bytes32 winnerHash;
    uint startTime;
    uint wait;
    bool winnerFound;
    bool over;

    // Declare each user.
    address payable owner; // owner will be one of the three, rules will be same for these three
    address payable user_1;
    address payable user_2;
    address payable user_3;

    // Initial money in each users account.
    uint amt1=0;
    uint amt2=0;
    uint amt3=0;

    // Lottery number of each user.
    uint L1;
    uint L2;
    uint L3;

    // Amount of lottery, 0 intially.
    uint lottery_prize=0;
    
    // For random number.
    uint nonce=0;

    // The first user to deploy is the starter of the lottery
    constructor() public payable{

        // Start the timer.
        startTime=now;

        // Set the owner.
        owner=msg.sender;

        // Each user gets same amount of money in the beginning.
        amt1+=msg.value;
        amt2+=msg.value;
        amt3+=msg.value;

        // Set wait time for lottery
        wait=3000;

        // Lottery is started
        winnerFound=false;
        over=false;
    }

    // Modifiers for each user's account info
    modifier only_user_1{
        require(msg.sender==user_1);
        _;
    }
    modifier only_user_2{
        require(msg.sender==user_2);
        _;
    }
    modifier only_user_3{
        require(msg.sender==user_3);
        _;
    }
    
    // Convert uint to bytes
    function toBytes(uint x) private pure returns (bytes memory b){
        b=new bytes(32);
        assembly{mstore(add(b, 32), x)}
    }
    
    // This fucntion returns a random number for Lottery number.
    function getRandomLotteryTicket() private returns (uint){
        uint randomnumber = uint(keccak256(abi.encodePacked(now, msg.sender, nonce))) % 900;
        randomnumber = randomnumber + 100;
        nonce++;
        return randomnumber;
    }

    // Initiate each user.
    function init_user1() public payable{
        user_1=msg.sender;
    }
    function init_user2() public payable{
        user_2=msg.sender;
    }
    function init_user3() public payable{
        user_3=msg.sender;
    }

    // Users buy lottery ticket
    function buyTicketUser1(uint price) public payable{
        // Check if the amount given by the user,
        // is greater than or equal to prize of lottery ticket
        require(price>=10); 

        // Check if he/she has enough amount of money in his/her account.
        require(price<=amt1); 

        // Check for the timer.
        require(now<startTime + (1000 * 1 seconds));

        amt1-=10;
        lottery_prize+=10;

        // Gets a lottery number.
        L1=getRandomLotteryTicket();
    }
    function buyTicketUser2(uint price) public payable{
        // Check if the amount given by the user,
        // is greater than or equal to prize of lottery ticket
        require(price>=10); 

        // Check if he/she has enough amount of money in his/her account.
        require(price<=amt2); 

        // Check for the timer.
        require(now<startTime + (2000 * 1 seconds));

        amt2-=10;
        lottery_prize+=10;

        // Gets a lottery number.
        L2=getRandomLotteryTicket();
    }
    function buyTicketUser3(uint price) public payable{
        // Check if the amount given by the user,
        // is greater than or equal to prize of lottery ticket
        require(price>=10); 

        // Check if he/she has enough amount of money in his/her account.
        require(price<=amt3); 

        // Check for the timer
        require(now<startTime + (3000 * 1 seconds));

        amt3-=10;
        lottery_prize+=10;

        // Gets a lottery number.
        L3=getRandomLotteryTicket();
    }

    // Fucntions if they want to communicate between each other 
    function send_u1_u2(uint amount) public only_user_1 payable{
        require(msg.sender==user_1);
        require(amount>0 && amount<=amt1);
        amt1-=amount;
        amt2+=amount;
    }
    function send_u2_u1(uint amount) public only_user_2 payable{
        require(msg.sender==user_2);
        require(amount>0 && amount<=amt2);
        amt2-=amount;
        amt1+=amount;
    }
    function send_u2_u3(uint amount) public only_user_2 payable{
        require(msg.sender==user_2);
        require(amount>0 && amount<=amt2);
        amt2-=amount;
        amt3+=amount;
    }
    function send_u3_u2(uint amount) public only_user_3 payable{
        require(msg.sender==user_3);
        require(amount>0 && amount<=amt3);
        amt3-=amount;
        amt2+=amount;
    }
    function send_u1_u3(uint amount) public only_user_1 payable{
        require(msg.sender==user_1);
        require(amount>0 && amount<=amt1);
        amt1-=amount;
        amt3+=amount;
    }
    function send_u3_u1(uint amount) public only_user_3 payable{
        require(msg.sender==user_3);
        require(amount>0 && amount<=amt3);
        amt3-=amount;
        amt1+=amount;
    }

    // Each user can check his/her balance, account of user A can't be seen by user B.
    function getBalU1() public only_user_1 view returns(uint){
        return amt1;
    }
    function getBalU2() public only_user_2 view returns(uint){
        return amt2;
    }
    function getBalU3() public only_user_3 view returns(uint){
        return amt3;
    }

    // Each user can check his/her lottery number.
    function getNumberU1() public only_user_1 view returns(uint){
        return L1;
    }
    function getNumberU2() public only_user_2 view returns(uint){
        return L2;
    }
    function getNumberU3() public only_user_3 view returns(uint){
        return L3;
    }
    
    // This fucntion returns choosing the winner from set{1, 2, 3}.
    function getWinnerRandomly() private returns (uint){
        uint randomnumber = uint(keccak256(abi.encodePacked(now, msg.sender, nonce))) % 3;
        randomnumber = randomnumber + 1;
        uint winner;
        if(randomnumber==1){
            winner=L1;
        }
        else if(randomnumber==2){
            winner=L2;
        }
        else{
            winner=L3;
        }
        nonce++;
        return winner;
    }
    
    // Owner starts the lottery
    function startLottery() public payable{
        require(msg.sender==owner);
        winnerHash=keccak256(toBytes(getWinnerRandomly()));
    }
    // Now selection is done.
    
    // Each user checks if he/she is the winner or not.
    function checU1(uint lottery_number) public payable{
        require(now<startTime + (wait * (1 seconds)));
        
        // Check if winnerHash matches with,
        // the hash of current user's lottery_number
        if(keccak256(toBytes(lottery_number))==winnerHash){
            // This user wins the lottery.
            amt1+=lottery_prize;
            
            winnerFound=true;
            over=true;
        }
    }
    function checU2(uint lottery_number) public payable{
        require(now<startTime + (wait * (1 seconds)));
        
        // Check if winnerHash matches with,
        // the hash of current user's lottery_number
        if(keccak256(toBytes(lottery_number))==winnerHash){
            // This user wins the lottery.
            amt2+=lottery_prize;
            
            winnerFound=true;
            over=true;
        }
    }
    function checU3(uint lottery_number) public payable{
        require(now<startTime + (wait * (1 seconds)));
        
        // Check if winnerHash matches with,
        // the hash of current user's lottery_number
        if(keccak256(toBytes(lottery_number))==winnerHash){
            // This user wins the lottery.
            amt3+=lottery_prize;
            
            winnerFound=true;
            over=true;
        }
    }

    // Check for the final status.
    function endTheLottery() public payable{
        require(msg.sender==owner);
        if(now>startTime + (wait * (1 seconds)) || winnerFound==false){
            // refund all the users, winner was not found under given time.
            amt1+=10;
            lottery_prize-=10;
            amt2+=10;
            lottery_prize-=10;
            amt3+=10;
            lottery_prize-=10;
            over=true;
        }
    }
}
