#!/usr/bin/env ruby
class Microwave
   def on
     puts "Microwave is on 1"
   end 
end

m = Microwave.new
m.on

class B< Microwave
    def on
     puts "Warning: Do not insert metal objects! 2"
   end
end 
b=B.new
b.on  # Message for this specific microwave

 class C<B
      def on
      alias :old_on2 Microwave.instance_method(:on).bind(self).name
       puts "This microwave is weak, add extra time 3"
       old_on2
      end
 end 
c=C.new
c.on # Displays extra message  m2 = Microwave.new m2.on # Does not display extra message 

