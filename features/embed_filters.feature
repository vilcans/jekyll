Feature: Embed filters
  As a hacker who likes to blog
  I want to be able to transform text inside a post or page
  In order to perform cool stuff in my posts

  Scenario: Convert date to XML schema
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout  | content                                     |
      | Star Wars | 3/27/2009 | default | These aren't the droids you're looking for. |
    And I have a default layout that contains "{{ site.time | date_to_xmlschema }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see today's date in "_site/2009/03/27/star-wars.html"

  Scenario: Escape text for XML
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title       | date      | layout  | content                                     |
      | Star & Wars | 3/27/2009 | default | These aren't the droids you're looking for. |
    And I have a default layout that contains "{{ site.posts.first.title | xml_escape }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "Star &amp; Wars" in "_site/2009/03/27/star-wars.html"

  Scenario: Escape Javascript string literal
    Given I have an "string-escaping.js" page that contains "'"\"
    And I have a _layouts directory
    And I have a default layout that contains "{{ content | string_escape }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "\'\"\\" in "_site/string-escaping.js"

  Scenario: Clean a string so it can be used as an NCName (e.g. as id attribute in html)
    Given I have an "valid.html" page that contains "{{ "abcdef" | ncname }}"
    And I have an "first_char_invalid.html" page that contains "{{ "36" | ncname }}"
    And I have an "invalid.html" page that contains "{{ "abc123+\@%._-z" | ncname }}"
    And I have an "spaces.html" page that contains "{{ "hello there" | ncname }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "abcdef" in "_site/valid.html"
    And I should see "_36" in "_site/first_char_invalid.html"
    And I should see "abc123_2B5C4025._-z" in "_site/invalid.html"
    And I should see "hello-there" in "_site/spaces.html"

  Scenario: Calculate number of words
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout  | content                                     |
      | Star Wars | 3/27/2009 | default | These aren't the droids you're looking for. |
    And I have a default layout that contains "{{ site.posts.first.content | xml_escape }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "7" in "_site/2009/03/27/star-wars.html"

  Scenario: Convert an array into a sentence
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout  | tags                   | content                                     |
      | Star Wars | 3/27/2009 | default | [scifi, movies, force] | These aren't the droids you're looking for. |
    And I have a default layout that contains "{{ site.posts.first.tags | array_to_sentence_string }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "scifi, movies, and force" in "_site/2009/03/27/star-wars.html"

  Scenario: Textilize a given string
    Given I have a _posts directory
    And I have a _layouts directory
    And I have the following post:
      | title     | date      | layout  | content                                      |
      | Star Wars | 3/27/2009 | default | These aren't the droids you're looking for. |
    And I have a default layout that contains "By {{ '_Obi-wan_' | textilize }}"
    When I run jekyll
    Then the _site directory should exist
    And I should see "By <p><em>Obi-wan</em></p>" in "_site/2009/03/27/star-wars.html"

