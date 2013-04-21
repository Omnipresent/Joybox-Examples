class GameLayer < Joybox::Core::Layer

  def on_enter

    @world = World.new gravity: [0.0, -9.8]

    schedule_update do | dt |

      @world.step delta: dt

    end
    # this should ideally be a PhysicsSprite so player can catch bananas. 
    # Moving PhysicsSprite will soon be added to JoyBox!
    @player_gorilla = Sprite.new file_name: 'gorilla.png', 
                                  position: [248, 224]

    bottom_layer = @world.new_body position: [0, 0], 
                            type: KStaticBodyType do

      edge_fixure start_point: CGPointMake(0,0), end_point: CGPointMake(590, 0),
                     friction: 0.3,
                     density: 0.5
    end
    @hero_gorilla = Sprite.new file_name: 'gorilla.png',position: [125, 35]
    @layer = PhysicsSprite.new file_name: 'greenstrip.png', body: bottom_layer

    self << @player_gorilla
    self << @layer

    self << @hero_gorilla

    init_controls
  end

  def init_controls

    on_touches_began do |touches, event|

      starting_touch = touches.any_object

      @starting_touch_location = starting_touch.location
    end



    on_touches_ended do |touches, event|
      end_touch = touches.any_object
      end_touch_location = end_touch.location
      @hero_gorilla.run_action Move.to duration: 1, position: [end_touch.location.x, 35]
    end

    @duration = 0
    @timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:'throwBanana', userInfo:nil, repeats:true)
  end

  def throwBanana
    @duration = @duration + 1
    banana = new_banana_sprite
    self << banana
    y = rand(80)
    x = rand(100)-50
    banana.body.apply_force force: (CGPointMake(x,y))
  end

  def new_banana_sprite
    banana_body = @world.new_body position: @player_gorilla.position,
                                      type: KDynamicBodyType do
        polygon_fixure box: [6, 6],
                       friction: 10.8,
                       density: 2.5
                       #,restitution: 0.5
    end 

    @banana_sprite = PhysicsSprite.new file_name: 'banana.png',
                                            body: banana_body

    #Collision is removed for now but will be added when player_gorilla can catch bananas
   # @world.when_collide banana_body do |collision_body, is_touching|

   #   @banana_sprite.file_name = 'banana_hit.png'
      #@enemy_gorilla.file_name = 'gorilla_hit.png'
      #@hero_gorilla.file_name = 'gorilla_hit.png'
   # end

    @banana_sprite
  end
  
end
