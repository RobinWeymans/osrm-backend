@routing @car @destination
Feature: Car - Destination only, no passing through

    Background:
        Given the profile "car"

    Scenario: Car - Destination only street
        Given the node map
            """
            a       e
              b c d

            x       y
            """

        And the ways
            | nodes | access      |
            | ab    |             |
            | bcd   | destination |
            | de    |             |
            | axye  |             |

        When I route I should get
            | from | to | route      |
            | a    | b  | ab,ab      |
            | a    | c  | ab,bcd,bcd |
            | a    | d  | ab,bcd,bcd |
            | a    | e  | axye,axye  |
            | e    | d  | de,de      |
            | e    | c  | de,bcd,bcd |
            | e    | b  | de,bcd,bcd |
            | e    | a  | axye,axye  |

    Scenario: Car - Destination only street
        Given the node map
            """
            a       e
              b c d

            x       y
            """

        And the ways
            | nodes | access      |
            | ab    |             |
            | bc    | destination |
            | cd    | destination |
            | de    |             |
            | axye  |             |

        When I route I should get
            | from | to | route       |
            | a    | b  | ab,ab       |
            | a    | c  | ab,bc,bc    |
            | a    | d  | ab,bc,cd    |
            | a    | e  | axye,axye   |
            | e    | d  | de,de       |
            | e    | c  | de,cd,cd    |
            | e    | b  | de,cd,bc    |
            | e    | a  | axye,axye   |

    Scenario: Car - Routing inside a destination only area
        Given the node map
            """
            a   c   e
              b   d
            x       y
            """

        And the ways
            | nodes | access      |
            | ab    | destination |
            | bc    | destination |
            | cd    | destination |
            | de    | destination |
            | axye  |             |

        When I route I should get
            | from | to | route          |
            | a    | e  | ab,bc,cd,de,de |
            | e    | a  | de,cd,bc,ab,ab |
            | b    | d  | bc,cd,cd       |
            | d    | b  | cd,bc,bc       |

    Scenario: Car - Routing around a way that becomes destination only
        Given the node map
            """
            b
             \
              |
              e++d++++++c--i
              |             \
               \             h--a
                \            |
                 \___________g
            """

        And the ways
            | nodes | access      | oneway |
            | ah    |             | no     |
            | ihg   |             | no     |
            | eg    |             | no     |
            | icde  |             | no     |
            | cde   | destination | no     |
            | eb    |             | no     |

        When I route I should get
            | from | to | route           | # |
            | i    | b  | ihg,eg,eb,eb    | # goes around access=destination, though restricted way starts at two node intersection |
            | b    | d  | eb,cde,cde      | # ends in restricted way correctly     |
            | b    | i  | eb,eg,ihg,ihg   | # goes around restricted way correctly |

    Scenario: Car - Routing around a way that becomes destination only
        Given the node map
            """
               a---c---b
                   +    \
                   +    |
                   d    |
                    \___e
            """

        And the ways
            | nodes | access      | oneway |
            | acbe  |             | no     |
            | cd    | destination | no     |
            | de    |             | no     |

        When I route I should get
            | from | to | route         |
            | e    | a  | acbe,acbe     |
            | d    | a  | de,acbe,acbe  |
            | c    | d  | cd,cd         |
