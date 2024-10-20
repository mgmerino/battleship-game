# Battleship

This is a simple implementation of the Battleship game in Ruby. It is a two-player game where each player has a board with ships on it. The players take turns to guess the location of the ships on the opponent's board. The first player to sink all the ships of the opponent wins the game.

## Usage

You can install the gem by running:

```bash
gem install battleship
```

After installing the gem, you can start the game by running:

```bash
battleship
```

## Technical Details

The game is implemented using the following classes:

- `Cell`: Represents a cell on the board. It has a state that can be either `:empty`, `:ship`, `:hit`, or `:miss`.
- `Grid`: Represents the board. It is responsible for placing the ships, and sending the attack to the cells.
- `Ship`: Represents a ship on the grid. It has a size and a direction and health points determined by its size.
- `Player`: Represents a player in the game. It has a grid and can make an attack on the opponent's grid.
- `Engine`: The main game engine that controls the flow of the game. It spawns the ships, switch turns and manages the attack.

The game is played in the terminal. The players can see their own board and the opponent's board. The players take turns to make an attack by entering the coordinates of the cell they want to attack. The game displays the result of the attack and the state of the opponent's board.

The terminal client is implemented the following classes:
- `Interface`: The main interface that displays the game state and takes input from the players.
- `Presenter`: The presenter that formats the game state for display in the terminal.
- `InputHandler`: The input handler that validates the input from the players.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/battleship.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
