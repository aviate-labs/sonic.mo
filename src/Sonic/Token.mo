module {
    public type TxError = {
        #InsufficientAllowance;
        #InsufficientBalance;
        #ErrorOperationStyle;
        #Unauthorized;
        #LedgerTrap;
        #ErrorTo;
        #Other;
        #BlockUsed;
        #AmountTooSmall;
    };

    public type Result = {
        #Ok  : Nat;
        #Err : TxError;
    };

    public type Metadata = {
        fee         : Nat;
        decimals    : Nat8;
        owner       : Principal;
        logo        : Text;
        name        : Text;
        totalSupply : Nat;
        symbol      : Text;
    };

    public type TokenInfo = {
        holderNumber : Nat64;
        deployTime   : Nat64;
        metadata     : Metadata;
        historySize  : Nat64;
        cycles       : Nat64;
        feeTo        : Principal;
    };

    public type Interface = actor {
        allowance : query (owner : Principal, spender : Principal) -> async Nat;
        approve : shared (spender : Principal, value : Nat) -> async Result;
        balanceOf : query (who : Principal) -> async Nat;
        decimals : query () -> async Nat8;
        getAllowanceSize : query () -> async Nat64;
        getBlockUsed : query () -> async [Nat64];
        getHolders : query (Nat64, Nat64) -> async [(Principal, Nat)];
        logo : query () -> async Text;
        getMetadata : query () -> async Metadata;
        getTokenInfo : query () -> async TokenInfo;
        getUserApprovals : query (Principal) -> async [(Principal, Nat)];
        historySize : query () -> async Nat64;
        isBlockUsed : query (Nat64) -> async Bool;
        mint : shared (subAccount : ?[Nat8], blockHeight : Nat64) -> async Result;
        name : query () -> async Text;
        owner : query () -> async Principal;
        setFee : shared (Nat) -> async ();
        setFeeTo : shared (Principal) -> async ();
        setGenesis : shared () -> async Result;
        setLogo : shared (Text) -> async ();
        setName : shared (Text) -> async ();
        setOwner : shared (Principal) -> async ();
        symbol : query () -> async (Text);
        totalSupply : query () -> async (Nat);
        transfer : shared (to : Principal, value : Nat) -> async Result;
        transferFrom : shared (from : Principal, to : Principal, value : Nat) -> async Result;
        withdraw : shared (value : Nat64, to : Text) -> async Result;
    };
};
