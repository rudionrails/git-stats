Simple git stats for your repository.

## Usage

`wget https://raw.github.com/rudionrails/git-stats/master/stats.rb`

```ruby
ruby stats.rb

#=> SCORE: 3 commits in 0.00484 seconds
#
#       | Name                 |  score |  commits |  changes | insertions |  deletions
#   ------------------------------------------------------------------------------------
#     1 | Rudolf Schmidt       |    138 |        2 |        1 |        137 |          0
#     2 | Kevin Jalbert        |      3 |        1 |        1 |          1 |          1
#
#
#   WHATCHANGED: 3 commits in 0.002492 seconds
#
#       | filename                                                          |  changes
#   -----------------------------------------------------------------------------------
#     1 | stats.rb                                                          |        2
#     2 | README                                                            |        1
```
