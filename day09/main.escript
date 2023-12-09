#!/usr/bin/env escript

-mode(compile).

main([Filename]) ->
  {ok, Data} = file:read_file(Filename),
  Lines = binary:split(Data, <<"\n">>, [global, trim_all]),
  Sequences = lists:map(fun(Line) -> parse_line(Line) end, Lines),
  Nexts = lists:map(fun(Sequence) -> next_number(Sequence) end, Sequences),
  Sum = lists:sum(Nexts),
  io:format("~p~n", [Sum]),
  SequencesRev = lists:map(fun(Sequence) -> lists:reverse(Sequence) end, Sequences),
  NextsRev = lists:map(fun(Sequence) -> next_number(Sequence) end, SequencesRev),
  SumRev = lists:sum(NextsRev),
  io:format("~p~n", [SumRev]).

parse_line(Line) ->
  Strs = binary:split(Line, <<" ">>, [global, trim_all]),
  Numbers = lists:map(fun(X) -> list_to_integer(binary_to_list(X)) end, Strs),
  Numbers.

next_number(Sequence) ->
  AllZeroes = allZeroes(Sequence),
  if
    AllZeroes -> 0;
    true -> lists:last(Sequence) + next_number(differences(Sequence))
  end.

differences([A, B | Rest]) ->
  if 
    length(Rest) == 0 -> [B - A];
    true -> [B - A | differences([B | Rest])]
  end.

allZeroes(List) ->
  lists:all(fun(X) -> X == 0 end, List).