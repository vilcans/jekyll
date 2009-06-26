Feature: Image tag
  I want to be able to easily add images to my pages and posts

  Scenario: Normal image tag
    Given I have an "index.html" page that contains "{% image test.png %}"
    And I have an 30x20 image file "test.png"
    When I run jekyll
    Then I should see "<img src=\"/test.png\" width=\"30\" height=\"20\" />" in "_site/index.html"
    And the _site/test.png file should exist

