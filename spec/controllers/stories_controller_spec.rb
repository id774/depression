# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../spec_helper'

describe StoriesController, 'Stories' do
  fixtures :all

  context 'にアクセスする場合' do

    def create_post(string)
      post 'create' , :story => {
        "text" => string
      }
    end

    describe '一覧表示' do
      it "一覧画面が表示される" do
        get 'index'
        response.should be_success
      end
    end

    describe '詳細' do
      it "詳細画面が表示される" do
        get 'show', :id => 1
        response.should be_success
      end
    end

    describe '新規作成' do
      it "新規作成画面が表示される" do
        get 'new'
        response.should be_success
      end
    end

    describe '鬱ツイート判定' do
      it "作成処理が正常終了する" do
        create_post("死死死")
        response.redirect_url.should == 'http://test.host/'
        response.header.should have_at_least(1).items
        response.body.should have_at_least(1).items
        flash[:notice].should_not be_nil
        flash[:notice].should eq '判定結果は「鬱ツイート」です'
        session[:result].should eq '判定結果は「鬱ツイート」です'
        session[:text].should eq "死死死"
        session[:classify].should eq "鬱ツイート"
        session[:total_score].should eq -0.2041627108542056
        session[:scores].should eq "[[\"死\",\"し\",\"名詞\",\"-0.588833\"],[\"死\",\"し\",\"名詞\",\"-0.588833\"],[\"死\",\"し\",\"名詞\",\"-0.588833\"]]"
      end

      it "新規レコードが作成される" do
        create_post("死死死")
        content = Story.find(2)
        content.text.should eq "死死死"
        content.classify.should eq "鬱ツイート"
        content.total_score.should <= -0.20
        Story.count.should eq 2
      end
    end

    describe '普通のツイート判定' do
      it "作成処理が正常終了する" do
        create_post("元気に生きる")
        response.redirect_url.should == 'http://test.host/'
        response.header.should have_at_least(1).items
        response.body.should have_at_least(1).items
        flash[:notice].should_not be_nil
        flash[:notice].should eq '判定結果は「普通のツイート」です'
        session[:result].should eq '判定結果は「普通のツイート」です'
        session[:text].should eq "元気に生きる"
        session[:classify].should eq "普通のツイート"
        session[:total_score].should eq 0.8873056004837514
        session[:scores].should eq "[[\"元気\",\"げんき\",\"名詞\",\"0.993766\"],[\"生きる\",\"いきる\",\"動詞\",\"0.928091\"]]"
      end

      it "新規レコードが作成される" do
        create_post("元気に生きる")
        content = Story.find(2)
        content.text.should eq "元気に生きる"
        content.classify.should eq "普通のツイート"
        content.total_score.should > -0.20
        Story.count.should eq 2
      end
    end

    describe 'ツイート判定不能' do
      it "作成処理が正常終了する" do
        create_post("元気モリモリ")
        response.redirect_url.should == 'http://test.host/'
        response.header.should have_at_least(1).items
        response.body.should have_at_least(1).items
        flash[:notice].should_not be_nil
        flash[:notice].should eq '判定結果は「判定不能」です'
        session[:result].should eq '判定結果は「判定不能」です'
        session[:text].should eq "元気モリモリ"
        session[:classify].should eq "判定不能"
        session[:total_score].should eq 0.0
        session[:scores].should eq "語彙が少なすぎて判定できません。もう少し語彙を増やしてください。"
      end

      it "新規レコードが作成される" do
        create_post("元気モリモリ")
        content = Story.find(2)
        content.text.should eq "元気モリモリ"
        content.classify.should eq "判定不能"
        content.total_score.should eq 0.0
        Story.count.should eq 2
      end
    end

  end
end
