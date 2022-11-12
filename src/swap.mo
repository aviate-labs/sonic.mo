import DIP20 "dip20";

module {
    public let CANISTER_ID = "3xwpq-ziaaa-aaaah-qcn4a-cai";

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

    public type SwapInfo = {
        /// Sonic canister creator.
        owner             : Principal;
        /// Sonic canister cycles balance.
        cycles            : Nat;
        /// Supported tokens info.
        tokens            : [TokenInfoExt];
        /// Supported pairs info.
        pairs             : [PairInfoExt];
    };

    public type UserInfo = {
        /// User lp token balances [(lp token id, balance)...].
        lpBalances : [(Text, Nat)];
        /// User token balances [(token id, balance)...].
        balances   : [(Text, Nat)];
    };

    public type UserInfoPage = {
        lpBalances : ([(Text, Nat)], Nat);
        balances   : ([(Text, Nat)], Nat);
    };

    /// These are the available methods that either pull data from or push updates to Sonic's swap canister.
    /// More Info: https://docs.sonic.ooo/dev/swaps-api
    public type SwapsInterface = actor {
        /// Returns an array that contains a PairInfoExt for all of existing swap pairs.
        getAllPairs : query () -> async [PairInfoExt];
        /// Returns the `PairInfoExt` for the `token0` and `token1` swap pairing, if a swap pair exists.
        getPair     : query (token0: Principal, token1: Principal) -> async ?PairInfoExt;
        /// Returns a `Nat` that represents the total number of swap pairs that exist on Sonic.
        getNumPairs : query () -> async Nat;
        /// Swap an `amountIn` amount of token A, and receive at least `amountOutMin` of Token B. Returns a `TxReceipt`.
        swapExactTokensForTokens : shared (
            amountIn     : Nat,
            amountOutMin : Nat,
            /// A text list [`fromTokenId`, `toTokenId`] that contains the input token and output token’s canister IDs.
            path         : [Text],
            /// A principal id that the tokens out are deposited at.
            to           : Principal,
            /// The time by which the swap has to be executed to be valid.
            deadline     : Int
        ) -> async DIP20.TxReceipt;
        /// Swap at most `amountInMax` of token A for exactly `amountOut` of Token B. Returns a `TxReceipt`.
        swapTokensForExactTokens : shared (
            amountOut    : Nat,
            amountInMax  : Nat,
            /// A text list [`fromTokenId`, `toTokenId`] that contains the input token and output token’s canister IDs.
            path         : [Text],
            /// A principal id that the tokens out are deposited at.
            to           : Principal,
            /// The time by which the swap has to be executed to be valid.
            deadline     : Int
        ) -> async DIP20.TxReceipt
    };

    /// These are the available methods that either pull data from or create updates on Sonic Liquidity Pools.
    /// More Info: https://docs.sonic.ooo/dev/liquidity-api
    public type LiquidityInterface = actor {
        /// Adds liquidity to the `token0` and `token1` liquidity pool.
        addLiquidity : shared (
            token0         : Principal,
            token1         : Principal,
            /// Represents the amounts you want to deposit into the liquidity pool. 
            amount0Desired : Nat,
            amount1Desired : Nat,
            /// The lowest amounts of each token you’re willing to add when the 
            /// function adjusts for the current ratio of the pool. 
            amount0Min     : Nat,
            amount1Min     : Nat,
            deadline       : Int
        ) -> async DIP20.TxReceipt;
        /// Returns an array of tuples that hold an LP tokenId and the associated balance held associated with `user`.
        getUserLPBalances : query (user: Principal) -> async [(tokenId : Text, balance : Nat)];
        /// Burns `lpAmount` of your LP tokens for the `token0` and `token1` liquidity
        /// pool in return for (`lpAmount` LP tokens) / (total LP tokens ) percent of the assets in the liquidity pool.
        removeLiquidity : shared (
            token0: Principal,
            token1: Principal,
            lpAmount: Nat,
            amount0Min: Nat,
            amount1Mint: Nat,
            deadline: Int
        ) -> async DIP20.TxReceipt;
    };

    /// These are the available methods that either pull data from or create updates on Sonic Assets.
    /// More Info: https://docs.sonic.ooo/dev/assets-api
    public type AssetsInterface = actor {
        /// Adds a DIP20 token that has a canister ID of `tokenId` to Sonic. Returns a `TxReceipt`.
        addToken     : shared (tokenId: Principal) -> async DIP20.TxReceipt;
        /// Gets the amount of token with canister ID of `tokenId` that `spender` 
        /// is allowed to spend of `owner`’s Sonic balance.
        allowance    :  query (tokenId : Text, owner : Principal, spender : Principal) -> async Nat;
        /// Allows `spender` to make transfers up to `value` amount of the token with canister id `tokenId` 
        /// from the `caller`'s Sonic balance. Returns a bool to indicate if the approval was successful.
        approve      : shared (tokenId : Text, spender : Principal, value : Nat) -> async Bool;
        /// Gets the balance that `who` has of the token `tokenId` in Sonic.
        balanceOf    :  query (tokenId : Text, who : Principal) -> async Nat;
        /// Adds a swap pair made up of `token0` and `token1` to Sonic. Both `token0` and `token1`
        /// must be Principal IDs of valid DIP20 tokens that are already added to Sonic. Returns a `TxReceipt`.
        createPair   : shared (token0: Principal, token1: Principal) -> async DIP20.TxReceipt;
        /// Gets the decimals of token with canister ID of `tokenId`.
        decimals     :  query (tokenId : Text) -> async Nat;
        /// Sends `value` amount of tokens with a canister id of `tokenId from the `caller`'s wallet balance 
        /// to the `caller`'s balance in Sonic. Assets must be deposited into Sonic before they can be used 
        /// for swaps and liquidity operations.
        deposit      : shared (tokenId : Principal, value : Nat) -> async DIP20.TxReceipt;
        /// Returns a list of `TokenInfoExt` objects.
        getSupportedTokenList : query () -> async [TokenInfoExt];
        /// Gets the name of the token with canister ID of `tokenId`.
        name         : query  (tokenId : Text) -> async Text;
        /// Gets the symbol of token with canister ID of `tokenId`.
        symbol       : query  (tokenId : Text) -> async Text;
        /// Gets the total supply of token with canister ID of `tokenId`.
        totalSupply  :  query (tokenId : Text) -> async Nat;
        /// Sends `value` amount of tokens with canister ID `tokenId` from the `caller`'s Sonic balance to 
        /// `to`’s Sonic balance. This will also work for sending Sonic LP Tokens.
        /// Returns a bool to indicate if the transfer was successful.
        transfer     : shared (tokenId : Text, to : Principal, value : Nat) -> async Bool;
        /// Sends `value` amount of token with canister ID `tokenId` from your allowance at `from`’s 
        /// Sonic balance to `to`’s balance in Sonic.
        transferFrom : shared (tokenId : Text, from : Principal, to : Principal, value : Nat) -> async DIP20.TxReceipt;
        /// Sends `value` amount of tokens with canister id `tokenId` from `caller`'s balance in Sonic back 
        // to `caller`'s wallet balance.
        withdraw     : shared (tokenId : Principal, value : Nat) -> async DIP20.TxReceipt;
    };

    public type OtherInterface = actor {
        /// Returns the token balances and LP token balances of `user`.
        getUserInfo : query (user : Principal) -> async UserInfo;
        /// Returns info on Sonic’s swap canister that includes but is not limited 
        /// to the available swap pairings, the canisters cycles balance, and the owner.
        getSwapInfo : query () -> async SwapInfo;
    };
};
