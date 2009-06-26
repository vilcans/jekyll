Feature: Image tag
  I want to be able to easily add images to my pages and posts

  Scenario: Normal image tag
    Given I have an "index.html" page that contains "{% image test.png %}"
    And I have an 30x20 image file "test.png"
    When I run jekyll
    Then I should see "<img src=\"/test.png\" width=\"30\" height=\"20\" />" in "_site/index.html"
    And the _site/test.png file should exist

  Scenario: Shrink image that is wider than threshold
    Given I have an "index.html" page that contains "{% image test.png max_width=20 %}"
    And I have an 100x50 image file "test.png"
    When I run jekyll
    Then I should see "<img src=\"/test_20x10.png\" width=\"20\" height=\"10\" />" in "_site/index.html"
    And the _site/test_20x10.png file should exist
    And the _site/test.png file should exist

  Scenario: Shrink image that is taller than threshold
    Given I have an "index.html" page that contains "{% image test.png max_height=10 %}"
    And I have an 100x50 image file "test.png"
    When I run jekyll
    Then I should see "<img src=\"/test_20x10.png\" width=\"20\" height=\"10\" />" in "_site/index.html"
    And the _site/test_20x10.png file should exist
    And the _site/test.png file should exist

