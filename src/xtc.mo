import DIP20 "dip20";
import RResult "rresult";

module {
    // NOTE: the interface and types are slightly different from DIP20.
    module ERC20 {
        public type Time = Int;

        public type Operation = {
            #approve;
            #mint;
            #transfer;
            #transferFrom;
            #burn;
            #canisterCalled;
            #canisterCreated;
        };

        public type TxRecord = {
            caller    : ?Principal;
            from      : Principal;
            to        : Principal;
            amount    : Nat;
            fee       : Nat;
            op        : Operation;
            timestamp : Time;
            index     : Nat;
            status    : TransactionStatus;
        };

        public type TxError = {
            #InsufficientAllowance;
            #InsufficientBalance;
            #ErrorOperationStyle;
            #Unauthorized;
            #LedgerTrap;
            #ErrorTo;
            #Other;
            #BlockUsed;
            #FetchRateFailed;
            #NotifyDfxFailed;
            #UnexpectedCyclesResponse;
            #AmountTooSmall;
            #InsufficientXTCFee;
        };

        public type TxReceipt = RResult.Result<Nat, TxError>;

        public type Interface = actor {
            allowance       : query  (Principal, Principal)      -> async (Nat);
            approve         : shared (Principal, Nat)            -> async (TxReceipt);
            balanceOf       : query  (Principal)                 -> async (Nat);
            decimals        : query  ()                          -> async (Nat8);
            getMetadata     : query  ()                          -> async (DIP20.Metadata);
            getTransaction  : shared (Nat)                       -> async (TxRecord);
            getTransactions : shared (Nat, Nat)                  -> async ([TxRecord]);
            historySize     : query  ()                          -> async (Nat);
            logo            : query  ()                          -> async (Text);
            nameErc20       : query  ()                          -> async (Text);
            name            : query  ()                          -> async (Text);
            symbol          : query  ()                          -> async (Text);
            totalSupply     : query  ()                          -> async (Nat);
            transferErc20   : shared (Principal, Nat)            -> async (TxReceiptLegacy);
            transfer        : shared (Principal, Nat)            -> async (TxReceipt);
            transferFrom    : shared (Principal, Principal, Nat) -> async (TxReceipt);
            mint            : shared (Principal, Nat)            -> async (MintResult);
            isBlockUsed     : query  (Nat64)                     -> async (Bool);
            getBlockUsed    : query  ()                          -> async ([Nat64]);
        };
    };

    public type TransactionId = Nat64;

    public type BurnError = {
        #InsufficientBalance;
        #InvalidTokenContract;
        #NotSufficientLiquidity;
    };

    public type BurnResult = RResult.Result<TransactionId, BurnError>;

    public type TxReceiptLegacy = RResult.Result<Nat, {
        #InsufficientAllowance;
        #InsufficientBalance;
    }>;

    public type MintError = {
        #NotSufficientLiquidity;
    };

    public type MintResult = RResult.Result<TransactionId, MintError>;

    public type CallResult = {
        // BUG(?) return : Blob;
        // Can not use "return" as a record field name.
        result : Blob;
    };

    public type ResultCall = RResult.Result<CallResult, Text>;

    public type CreateResult = RResult.Result<{ canister_id: Principal }, Text>;

    public type EventDetail = {
        #Transfer : {
            from : Principal;
            to   : Principal;
        };
        #Mint     : {
            to   : Principal;
        };
        #Burn     : {
            from : Principal;
            to   : Principal;
        };
        #CanisterCalled : {
            from        : Principal;
            canister    : Principal;
            method_name : Text;
        };
        #CanisterCreated : {
            from     : Principal;
            canister : Principal;
        };
        #TransferFrom : {
            caller : Principal;
            from   : Principal;
            to     : Principal;
        };
        #Approve : {
            from : Principal;
            to   : Principal;
        };
    };

    public type TransactionStatus = {
        #SUCCEEDED;
        #FAILED;
    };

    public type Event = {
        fee       : Nat64;
        kind      : EventDetail;
        cycles    : Nat64;
        timestamp : Nat64;
        status    : TransactionStatus;
    };

    public type EventsConnection = {
        data             : [Event];
        next_offset      : TransactionId;
        next_canister_id : ?Principal;
    };

    public type Stats = {
        supply                  : Nat;
        fee                     : Nat;
        history_events          : Nat64;
        balance                 : Nat64;
        transfers_count         : Nat64;
        transfers_from_count    : Nat64;
        approvals_count         : Nat64;
        mints_count             : Nat64;
        burns_count             : Nat64;
        proxy_calls_count       : Nat64;
        canisters_created_count : Nat64;
    };

    public type ResultSend = RResult.Result<(), Text>;

    /// More Info: https://github.com/Psychedelic/dank/blob/develop/candid/xtc.did
    public type Interface = actor {
        get_map_block_used  : query  (Nat64)                     -> async (?Nat64); // ICP burned block
        mint_by_icp         : shared (?[Nat8], Nat64)            -> async (ERC20.TxReceipt);
        mint_by_icp_recover : shared (?[Nat8], Nat64, Principal) -> async (ERC20.TxReceipt);

        burn    : shared ({ canister_id: Principal; amount: Nat64 }) -> async (BurnResult);
        balance : shared (?Principal)                                -> async (amount: Nat64);

        // History
        get_transaction : shared (id : TransactionId)               -> async (?Event);
        events          : query  ({ offset: ?Nat64; limit: Nat16 }) -> async (EventsConnection);

        // Management
        halt : shared () -> async ();

        // Usage statistics
        stats : query () -> async (Stats);

        // ----------- Cycles wallet compatible API
        wallet_balance : query  ()                                       -> async ({ amount: Nat64 });
        wallet_send    : shared ({ canister: Principal; amount: Nat64 }) -> async (ResultSend);

        // Managing canister
        wallet_create_canister : shared ({
            cycles     : Nat64;
            controller : ?Principal;  // If omitted, set the controller to the caller.
        }) -> async (CreateResult);

        wallet_create_wallet : shared ({
            cycles     : Nat64;
            controller : ?Principal;
        }) -> async (CreateResult);

        // Call Forwarding
        wallet_call : shared ({
            canister    : Principal;
            method_name : Text;
            args        : Blob;
            cycles      : Nat64;
        }) -> async (ResultCall);
    };
};
