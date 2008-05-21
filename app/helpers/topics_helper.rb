module Merb
    module TopicsHelper
      def edit_post_link(forum,topic,post)
            link_to('Edit', 
                    url(:edit_forum_topic_post, 
                        {:forum_id => forum, :topic_id => topic, :id => post}),
                    :class => 'edit')
      end
    end
end
