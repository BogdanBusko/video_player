require "video_player/version"

module VideoPlayer
  def self.player(*args)
    VideoPlayer::Parser.new(*args).embed_code
  end

  class Parser
    YOUTUBE_REGEX  = /\A(https?:\/\/)?(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?/i
    VIMEO_REGEX    = /\Ahttps?:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/i
    IZLESENE_REGEX = /\Ahttp:\/\/(?:.*?)\izlesene\.com\/video\/([\w\-\.]+[^#?\s]+)\/(.*)?$/i
    WISTIA_REGEX   = /\Ahttps?:\/\/(.+)?(wistia.com|wi.st)\/(medias|embed)\/([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?/i

    attr_accessor :url, :width, :height, :allow_full_screen

    def initialize(url, width: 440, height: 200, autoplay: true, allow_full_screen: true, show_controls: true)
      @url = url
      @width = width
      @height = height
      @autoplay = autoplay
      @allow_full_screen = allow_full_screen
      @show_controls = show_controls
    end

    def embed_code
      case
      when matchdata = url.match(YOUTUBE_REGEX)
        youtube_embed(matchdata[4])
      when matchdata = url.match(VIMEO_REGEX)
        vimeo_embed(matchdata[2])
      when matchdata = url.match(IZLESENE_REGEX)
        izlesene_embed(matchdata[2])
      when matchdata = url.match(WISTIA_REGEX)
        wistia_embed(matchdata[4])
      else
        false
      end
    end


    def iframe_code(src)
      full_screen = allow_full_screen ? 'webkitallowfullscreen mozallowfullscreen allowfullscreen' : ''

      "<iframe src=\"#{src}\" width=\"#{width}\" height=\"#{height}\" frameborder=\"0\" #{full_screen}></iframe>"
    end

    def youtube_embed(video_id)
      src = "//www.youtube.com/embed/#{video_id}?autoplay=#{autoplay}&controls=#{controls}&disablekb=#{controls}&rel=0"
      iframe_code(src)
    end

    def vimeo_embed(video_id)
      src = "//player.vimeo.com/video/#{video_id}"
      iframe_code(src)
    end

    def izlesene_embed(video_id)
      src = "//www.izlesene.com/embedplayer/#{video_id}/?autoplay=#{autoplay}&showrel=0&showinfo=0"
      iframe_code(src)
    end

    def wistia_embed(video_id)
      src = "//fast.wistia.net/embed/iframe/#{video_id}/?autoplay=#{autoplay}&showrel=0&showinfo=0"
      iframe_code(src)
    end

    private

    def autoplay
      autoplay ? '1' : '0'
    end

    def controls
      show_controls ? '1' : '0'
    end
  end
end
