:- use_module(library(dcg/basics)).

% whitespace

% arbitrary sequences for debugging
seq([]) --> [].
seq([X|Xs]) --> [X], seq(Xs).

numlist([]) --> [].
numlist([X]) --> integer(X).
numlist([X|Xs]) --> integer(X), " ", numlist(Xs).

seeds(Seeds) --> "seeds: ", numlist(Seeds), blanks.

map([]) --> [].
map([[A,B,C]|Xs]) --> integer(A), " ", integer(B), " ", integer(C), eol, map(Xs).
namedMap(Name, Map) --> Name, " map:", eol, map(Map), blanks.

seedToSoilD(SeedToSoil) --> namedMap("seed-to-soil", SeedToSoil).
soilToFertilizerD(SoilToFertilizer) --> namedMap("soil-to-fertilizer", SoilToFertilizer).
fertilizerToWaterD(FertilizerToWater) --> namedMap("fertilizer-to-water", FertilizerToWater).
waterToLightD(WaterToLight) --> namedMap("water-to-light", WaterToLight).
lightToTemperatureD(LightToTemperature) --> namedMap("light-to-temperature", LightToTemperature).
temperatureToHumidityD(TemperatureToHumidity) --> namedMap("temperature-to-humidity", TemperatureToHumidity).
humidityToLocationD(HumidityToLocation) --> namedMap("humidity-to-location", HumidityToLocation).

input((Seeds, SeedToSoil, SoilToFertilizer, FertilizerToWater, WaterToLight, LightToTemperature, TemparatureToHumidity, HumidityToLocation)) -->
  seeds(Seeds),
  seedToSoilD(SeedToSoil),
  soilToFertilizerD(SoilToFertilizer),
  fertilizerToWaterD(FertilizerToWater),
  waterToLightD(WaterToLight),
  lightToTemperatureD(LightToTemperature),
  temperatureToHumidityD(TemparatureToHumidity),
  humidityToLocationD(HumidityToLocation).

read_input(I, File) :- 
  phrase_from_file(input(I), File).

seedI(I, Seed) :- I = (Seeds, _, _, _, _, _, _, _), member(Seed, Seeds).
seedToSoilI(I, DestStart, SourceStart, Length) :- I = (_, SeedToSoil, _, _, _, _, _, _), member([DestStart, SourceStart, Length], SeedToSoil).
soilToFertilizerI(I, DestStart, SourceStart, Length) :- I = (_, _, SoilToFertilizer, _, _, _, _, _), member([DestStart, SourceStart, Length], SoilToFertilizer).
fertilizerToWaterI(I, DestStart, SourceStart, Length) :- I = (_, _, _, FertilizerToWater, _, _, _, _), member([DestStart, SourceStart, Length], FertilizerToWater).
waterToLightI(I, DestStart, SourceStart, Length) :- I = (_, _, _, _, WaterToLight, _, _, _), member([DestStart, SourceStart, Length], WaterToLight).
lightToTemperatureI(I, DestStart, SourceStart, Length) :- I = (_, _, _, _, _, LightToTemperature, _, _), member([DestStart, SourceStart, Length], LightToTemperature).
temperatureToHumidityI(I, DestStart, SourceStart, Length) :- I = (_, _, _, _, _, _, TemperatureToHumidity, _), member([DestStart, SourceStart, Length], TemperatureToHumidity).
humidityToLocationI(I, DestStart, SourceStart, Length) :- I = (_, _, _, _, _, _, _, HumidityToLocation), member([DestStart, SourceStart, Length], HumidityToLocation).

isMapped([DestStart, SrcStart, Length], SrcLoc, DestLoc) :- Offset is SrcLoc - SrcStart, Offset>=0, Offset<Length, DestLoc is DestStart + Offset.

seed(I, X) :- seedI(I, X). % true when seed at X

% true when seed at X is in soil Y
seedToSoil_(I,SrcLoc,DestLoc) :- 
  seedToSoilI(I,DestStart,SrcStart,Length), 
  isMapped([DestStart, SrcStart, Length], SrcLoc, DestLoc).
seedToSoil(I,SrcLoc,DestLoc) :- seedToSoil_(I,SrcLoc,DestLoc).
seedToSoil(I,SrcLoc,DestLoc) :- \+seedToSoil_(I,SrcLoc,DestLoc), SrcLoc=DestLoc.

% true when soil at X is in fertilizer Y
soilToFertilizer_(I,SrcLoc,DestLoc) :- 
  soilToFertilizerI(I,DestStart,SrcStart,Length), 
  isMapped([DestStart, SrcStart, Length], SrcLoc, DestLoc).
soilToFertilizer(I,SrcLoc,DestLoc) :- soilToFertilizer_(I,SrcLoc,DestLoc).
soilToFertilizer(I,SrcLoc,DestLoc) :- \+soilToFertilizer_(I,SrcLoc,DestLoc), SrcLoc=DestLoc.

% true when fertilizer at X is in water Y
fertilizerToWater_(I,SrcLoc,DestLoc) :- 
  fertilizerToWaterI(I,DestStart,SrcStart,Length), 
  isMapped([DestStart, SrcStart, Length], SrcLoc, DestLoc).
fertilizerToWater(I,SrcLoc,DestLoc) :- fertilizerToWater_(I,SrcLoc,DestLoc).
fertilizerToWater(I,SrcLoc,DestLoc) :- \+fertilizerToWater_(I,SrcLoc,DestLoc), SrcLoc=DestLoc.

% true when water at X is in light Y
waterToLight_(I,SrcLoc,DestLoc) :- 
  waterToLightI(I,DestStart,SrcStart,Length), 
  isMapped([DestStart, SrcStart, Length], SrcLoc, DestLoc).
waterToLight(I,SrcLoc,DestLoc) :- waterToLight_(I,SrcLoc,DestLoc).
waterToLight(I,SrcLoc,DestLoc) :- \+waterToLight_(I,SrcLoc,DestLoc), SrcLoc=DestLoc.

% true when light at X is in temperature Y
lightToTemperature_(I,SrcLoc,DestLoc) :- 
  lightToTemperatureI(I,DestStart,SrcStart,Length), 
  isMapped([DestStart, SrcStart, Length], SrcLoc, DestLoc).
lightToTemperature(I,SrcLoc,DestLoc) :- lightToTemperature_(I,SrcLoc,DestLoc).
lightToTemperature(I,SrcLoc,DestLoc) :- \+lightToTemperature_(I,SrcLoc,DestLoc), SrcLoc=DestLoc.

% true when temperature at X is in humidity Y
temperatureToHumidity_(I,SrcLoc,DestLoc) :- 
  temperatureToHumidityI(I,DestStart,SrcStart,Length), 
  isMapped([DestStart, SrcStart, Length], SrcLoc, DestLoc).
temperatureToHumidity(I,SrcLoc,DestLoc) :- temperatureToHumidity_(I,SrcLoc,DestLoc).
temperatureToHumidity(I,SrcLoc,DestLoc) :- \+temperatureToHumidity_(I,SrcLoc,DestLoc), SrcLoc=DestLoc.

% true when humidity at X is in location Y
humidityToLocation_(I,SrcLoc,DestLoc) :- 
  humidityToLocationI(I,DestStart,SrcStart,Length), 
  isMapped([DestStart, SrcStart, Length], SrcLoc, DestLoc).
humidityToLocation(I,SrcLoc,DestLoc) :- humidityToLocation_(I,SrcLoc,DestLoc).
humidityToLocation(I,SrcLoc,DestLoc) :- \+humidityToLocation_(I,SrcLoc,DestLoc), SrcLoc=DestLoc.

soil(I,Loc) :- seed(I,SrcLoc), seedToSoil(I,SrcLoc,Loc). % true when soil at X
fertilizer(I,Loc) :- soil(I,SrcLoc), soilToFertilizer(I,SrcLoc,Loc). % true when fertilizer at X
water(I,Loc) :- fertilizer(I,SrcLoc), fertilizerToWater(I,SrcLoc,Loc). % true when water at X
light(I,Loc) :- water(I,SrcLoc), waterToLight(I,SrcLoc,Loc). % true when light at X
temperature(I,Loc) :- light(I,SrcLoc), lightToTemperature(I,SrcLoc,Loc). % true when temperature at X
humidity(I,Loc) :- temperature(I,SrcLoc), temperatureToHumidity(I,SrcLoc,Loc). % true when humidity at X
location(I,Loc) :- humidity(I,SrcLoc), humidityToLocation(I,SrcLoc,Loc). % true when location at X

part1(X) :- once(read_input(I, "input.txt")), location(I, X), \+ (location(I,Y), Y<X). % true when location at X is the first location
