#!/usr/bin/env ruby

require 'benchmark'

module Git

  def self.run
    [Score.run, Whatchanged.run].join( "\n\n" )
  end
  
  class Score
    def self.run; new.run; end
    
    def initialize
      @commits = 0
      @stats = {}
      @time = 0
      
      @pipe = open( "|git log --pretty=format:'Author: %an' --shortstat --no-merges" )
    end
    
    def run
      @time = Benchmark.realtime { digest }
      
      print
    end
    
    
    private
    
    def digest
      author = "unknown"
      
      loop do
        line = @pipe.readline rescue break
        
        if m = line.match( /Author: (.+)/ )
          author = m[1]
          @commits += 1
        end
        
        if m = line.match( /(\d+) files changed, (\d+) insertions\(\+\), (\d+) deletions/ )
          a = ( @stats[ author ] ||= Hash.new(0) )
          
          a[ :commits ] += 1
          a[ :changes ] += m[1].to_i
          a[ :insertions ] += m[2].to_i
          a[ :deletions ] += m[3].to_i
          
          a[ :score ] += m[1].to_i + m[2].to_i + m[3].to_i
        end
      end
    end
    
    def print
      pattern = " %2s | %-20s | %6s | %8s | %8s | %10s | %10s" 

      @print = "SCORE: #{@commits} commits in #{@time} seconds\n\n"

      @print += pattern % ['', 'Name', 'score', 'commits', 'changes', 'insertions', 'deletions']    
      @print += ["\n", "-" * 84, "\n"].join
      
      position = 1
      @stats.sort_by { |_,score| -score[:score] }.each do |author, score|
        
        @print += pattern % [position, author[0,20], score[:score], score[:commits], score[:changes], score[:insertions], score[:deletions]]
        @print += "\n"
        
        position += 1
      end
      
      @print
    end
  end
  
  class Whatchanged
    def self.run; new.run; end
    
    def initialize( limit = 30 )
      @limit = limit
      @commits = 0
      @stats = Hash.new(0)
      @time = 0
      
      @pipe = open( "|git whatchanged --oneline --no-merges" )
    end
    
    def run
      @time = Benchmark.realtime { digest }
      
      print
    end
    
    
    private
    
    def digest
      filename = ""
      
      loop do
        line = @pipe.readline rescue break
        
        unless line.match( /^:/ )
          @commits += 1 
        else
          line.strip =~ /[AMD]\s*(.+)$/
          @stats[ $1 ] += 1
        end
      end
    end
    
    def print
      pattern = " %2s | %-65s | %8s" 

      @print =  "WHATCHANGED: #{@commits} commits in #{@time} seconds\n\n"

      @print +=  pattern % ['', 'filename', 'changes' ]
      @print += ["\n", "-" * 83, "\n"].join
      
      position = 1
      @stats.sort_by { |_,count| -count }.each do |filename, count|
        break if position > @limit
        
        @print += pattern % [position, filename, count]
        @print += "\n"
        
        position += 1
      end
      
      @print
    end
  end
  
end


puts Git.run
