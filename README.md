
# Fifty Bird

## States

- ShowingTitle
- CountingDown
- PlayingGame
- ShowingScore

ShowingTitle > CountingDown > PlayingGame > ShowingScore > CountingDown . . .

## Assignment 1

- Make pipe gaps slightly random (2nd:NotStarted)
- Make pipe intervals slightly random (1st:InProgress)
  - Currently handled in `PlayingGame:update` as the constant 2
    - Introduce a millisecond value of noise that will provide a random number.
      This random number will be less than the constant - valueOfNoise / 2 and
      no more than constant + valueOfNoise / 2
      (e.g. - constant: 2, value of noise: 5 -> floor: 1.75s, ceiling: 2.25s)
      - UPDATE:
        - Added noise variable to `PlayingGame`
        - when timer initially reaches limit, new limit is a random number between limit - (noise / 2) and limit + (noise / 2)
          - currently retrieving exact random numbers
          - <http://lua-users.org/wiki/MathLibraryTutorial> may hold some insight towards improving the outcome
          - `math.randomseed(os.time()); math.random(); math.random(); math.random` ???
- Award players a "medal" based on their score, using images (3rd:NotStarted)
  - This will be provided post-game when the final score is tallied
  - There is a minimum qualifying score for these awards
  - There will be three (3) different awards
- Implement a pause feature (4th:NotStarted)
  - This feature sets a flag that is used to determine whether to apply
    updates or not.
    - add flag `paused`
    - add condition check to `love.keypressed` for `p` and `space` keys to set `pause`
    - add condition check to `love.update` for `paused` to run `StateMachine:update`
