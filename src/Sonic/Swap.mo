// DOCS: https://docs.sonic.ooo/dev
module {
    public let CANISTER_ID = "3xwpq-ziaaa-aaaah-qcn4a-cai";

    public type TxReceipt = {
        #ok  : Nat;
        #err : Text;
    };

    public type Result = {
        #ok  : Bool;
        #err : Text;
    };

    public type PairInfoExt = {
        id                   : Text;
        price0CumulativeLast : Nat;
        creator              : Principal;
        reserve0             : Nat;
        reserve1             : Nat;
        lptoken              : Text;
        totalSupply          : Nat;
        token0               : Text;
        token1               : Text;
        price1CumulativeLast : Nat;
        kLast                : Nat;
        blockTimestampLast   : Int;
    };

    public type TokenInfoExt = {
        id          : Text;
        fee         : Nat;
        decimals    : Nat8;
        name        : Text;
        totalSupply : Nat;
        symbol      : Text;
    };

    public type DSwapInfo = {
        storageCanisterId : Principal;
        owner             : Principal;
        cycles            : Nat;
        tokens            : [TokenInfoExt];
        pairs             : [PairInfoExt];
    };

    public type UserInfo = {
        lpBalances : [(Text, Nat)];
        balances   : [(Text, Nat)];
    };

    public type UserInfoPage = {
        lpBalances : ([(Text, Nat)], Nat);
        balances   : ([(Text, Nat)], Nat);
    };

    public type Interface = actor {
        addAuth : shared (Principal) -> async Bool;
        addLiquidity : shared (
            Principal,
            Principal,
            Nat,
            Nat,
            Nat,
            Nat,
            Int,
        ) -> async TxReceipt;
        addToken : shared (Principal) -> async Result;
        allowance : query (Text, Principal, Principal) -> async Nat;
        approve : shared (Text, Principal, Nat) -> async Bool;
        balanceOf : query (Text, Principal) -> async Nat;
        checkTxCounter : shared () -> async Bool;
        createPair : shared (Principal, Principal) -> async TxReceipt;
        decimals : query (Text) -> async Nat8;
        deposit : shared (Principal, Nat) -> async TxReceipt;
        depositTo : shared (Principal, Principal, Nat) -> async TxReceipt;
        getAllPairs : query () -> async [PairInfoExt];
        getDSwapInfo : query () -> async DSwapInfo;
        getLPTokenId : query (Principal, Principal) -> async Text;
        getNumPairs : query () -> async Nat;
        getPair : query (Principal, Principal) -> async ?PairInfoExt;
        getPairs: query (Nat, Nat) -> async ([PairInfoExt], Nat);
        getSupportedTokenList : query () -> async [TokenInfoExt];
        getSupportedTokenListByName : query (Text, Nat, Nat) -> async ([TokenInfoExt], Nat);
        getSupportedTokenListSome : query (Nat, Nat) -> async ([TokenInfoExt], Nat);
        getUserBalances : query (Principal) -> async [(Text, Nat)];
        getUserInfo : query (Principal) -> async UserInfo;
        getUserInfoAbove : query (Principal, Nat, Nat) -> async UserInfo;
        getUserInfoByNamePageAbove : query (
            Principal,
            Int,
            Text,
            Nat,
            Nat,
            Int,
            Text,
            Nat,
            Nat,
        ) -> async UserInfoPage;
        getUserLPBalances : query (Principal) -> async [(Text, Nat)];
        getUserLPBalancesAbove : query (Principal, Nat) -> async [(Text, Nat)];
        lazySwap : shared (Nat, Nat, [Text], Principal) -> async TxReceipt;
        name : query (Text) -> async Text;
        removeAuth : shared (Principal) -> async Bool;
        removeLiquidity : shared (
            Principal,
            Principal,
            Nat,
            Nat,
            Nat,
            Principal,
            Int,
        ) -> async TxReceipt;
        setAddTokenThresh : shared (Nat) -> async Bool;
        setFeeForToken : shared (Text, Nat) -> async Bool;
        setFeeOn : shared (Bool) -> async Bool;
        setFeeTo : shared (Principal) -> async Bool;
        setGlobalTokenFee : shared (Nat) -> async Bool;
        setMaxTokens : shared (Nat) -> async Bool;
        setOwner : shared (Principal) -> async Bool;
        setStorageCanisterId : shared (Principal) -> async Bool;
        swapExactTokensForTokens: shared (
            Nat,
            Nat,
            [Text],
            Principal,
            Int
        ) -> async TxReceipt;
        swapTokensForExactTokens : shared (
            Nat,
            Nat,
            [Text],
            Principal,
            Int
        ) -> async TxReceipt;
        symbol : query (Text) -> async Text;
        totalSupply : query (Text) -> async Nat;
        transfer : shared (Text, Principal, Nat) -> async Bool;
        transferFrom : shared (Text, Principal, Principal, Nat) -> async Bool;
        withdraw : shared (Principal, Nat) -> async TxReceipt;
        withdrawTo : shared (Principal, Principal, Nat) -> async TxReceipt;
    };
};
