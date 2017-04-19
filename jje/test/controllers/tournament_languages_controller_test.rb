require 'test_helper'

class TournamentLanguagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tournament_language = tournament_languages(:one)
  end

  test "should get index" do
    get tournament_languages_url
    assert_response :success
  end

  test "should get new" do
    get new_tournament_language_url
    assert_response :success
  end

  test "should create tournament_language" do
    assert_difference('TournamentLanguage.count') do
      post tournament_languages_url, params: { tournament_language: {  } }
    end

    assert_redirected_to tournament_language_url(TournamentLanguage.last)
  end

  test "should show tournament_language" do
    get tournament_language_url(@tournament_language)
    assert_response :success
  end

  test "should get edit" do
    get edit_tournament_language_url(@tournament_language)
    assert_response :success
  end

  test "should update tournament_language" do
    patch tournament_language_url(@tournament_language), params: { tournament_language: {  } }
    assert_redirected_to tournament_language_url(@tournament_language)
  end

  test "should destroy tournament_language" do
    assert_difference('TournamentLanguage.count', -1) do
      delete tournament_language_url(@tournament_language)
    end

    assert_redirected_to tournament_languages_url
  end
end
