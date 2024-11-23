extends Control

var leaderboard = []

func scorekeep(player_name: String, score: int):
	leaderboard.append({"name": player_name, "score": score})
	leaderboard.sort()
	leaderboard.reverse()
	if leaderboard.size() > 10:
		leaderboard.pop_back
