%%
%% Copyright (c) 2017 Dmitry Poroh
%% All rights reserved.
%% Distributed under the terms of the MIT License. See the LICENSE file.
%%
%% Common SIP transaction interface
%%

-module(ersip_trans).
-export([id/1]).

-type trans()  :: ersip_trans_client:trans_client()
                | ersip_trans_server:trans_server().
-type tid()    :: {tid, ersip_trans_id:transaction_id()}.

-export_type([trans/0,
              tid/0
             ]).

%%%===================================================================
%%% API
%%%===================================================================

-spec id(trans()) -> tid().
id(Trans) ->
    call_trans_module(id, Trans, [Trans]).

%%%===================================================================
%%% Internal implementation
%%%===================================================================

call_trans_module(FunId, Transaction, Args) ->
    Module =
        case classify(Transaction) of
            trans_client -> ersip_trans_client;
            trans_server -> ersip_trans_server
        end,
    erlang:apply(Module, FunId, Args).

-spec classify(trans()) -> trans_client | trans_server.
classify(Trans) ->
    element(1, Trans).
