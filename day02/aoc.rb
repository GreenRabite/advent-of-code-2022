require 'csv'

inputs = []
CSV.foreach("./input.txt") do |row|
  inputs << row[0]
end

RPS_SCORE = {
  X: 1, #rock
  Y: 2, #paper
  Z: 3 #scissors
}

RPS_VS_OPPONENT_SCORE_MAPPING = {
  A: {
    Y: 6,
    Z: 0
  },
  B: {
    X: 0,
    Z: 6
  },
  C: {
    X: 6,
    Y: 0
  }
}

OPPONENT_RPS_MAPPING = {
  A: 'X', #rock
  B: 'Y', #paper
  C: 'Z' #scissors
}

def find_rps_result(opponent, you)
  oppo_value = OPPONENT_RPS_MAPPING[opponent.to_sym]
  return 3 if oppo_value === you

  RPS_VS_OPPONENT_SCORE_MAPPING[opponent.to_sym][you.to_sym]
end

score = inputs.reduce(0) do |accum,input|
  opponent, you = input.split(" ")

  accum += RPS_SCORE[you.to_sym] + find_rps_result(opponent, you)
end

RESULTS_MAPPING_SCORE = {
  X: 0,
  Y: 3,
  Z: 6
}

RESULT_VS_OPPONENT_SCORE_MAPPING = {
  A: {
    X: 3, # they throw rock, you throw scissors
    Z: 2 # they throw rock, you throw paper
  },
  B: {
    X: 1, # they throw paper, you throw rock
    Z: 3 # they throw paper, you throw scissors
  },
  C: {
    X: 2, # they throw scissors, you throw paper
    Z: 1 # they throw scissors, you throw rock
  }
}

def find_points_for_shape_to_throw(opponent, result)
  return RPS_SCORE[OPPONENT_RPS_MAPPING[opponent.to_sym].to_sym] if result === 'Y'

  RESULT_VS_OPPONENT_SCORE_MAPPING[opponent.to_sym][result.to_sym]
end

second_score = inputs.reduce(0) do |accum,input|
  opponent, you = input.split(" ")

  accum += find_points_for_shape_to_throw(opponent, you) + RESULTS_MAPPING_SCORE[you.to_sym]
end

puts "Part A: #{score}"
puts "Part B: #{second_score}"



