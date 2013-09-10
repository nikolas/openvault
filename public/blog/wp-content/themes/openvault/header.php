<?php
/**
 * The Header for our theme.
 *
 * Displays all of the <head> section and everything up till <div id="main">
 *
 * @package WordPress
 * @subpackage Twenty Eleven
 * @since Twenty Eleven 1.0
 */
?><!DOCTYPE html>
<!--[if IE 6]>
<html id="ie6" <?php language_attributes(); ?>>
<![endif]-->
<!--[if IE 7]>
<html id="ie7" <?php language_attributes(); ?>>
<![endif]-->
<!--[if IE 8]>
<html id="ie8" <?php language_attributes(); ?>>
<![endif]-->
<!--[if !(IE 6) | !(IE 7) | !(IE 8)  ]><!-->
<html <?php language_attributes(); ?>>
<!--<![endif]-->
<head>
<meta charset="<?php bloginfo( 'charset' ); ?>" />
<meta name="viewport" content="width=device-width" />
<title><?php
	/*
	 * Print the <title> tag based on what is being viewed.
	 */
	global $page, $paged;

	wp_title( '|', true, 'right' );

	// Add the blog name.
	bloginfo( 'name' );

	// Add the blog description for the home/front page.
	$site_description = get_bloginfo( 'description', 'display' );
	if ( $site_description && ( is_home() || is_front_page() ) )
		echo " | $site_description";

	// Add a page number if necessary:
	if ( $paged >= 2 || $page >= 2 )
		echo ' | ' . sprintf( __( 'Page %s', 'twentyeleven' ), max( $paged, $page ) );

	?></title>
<link rel="profile" href="http://gmpg.org/xfn/11" />
<link href="/assets/application.css?body=1" media="screen" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<?php bloginfo( 'stylesheet_url' ); ?>" />
<link rel="pingback" href="<?php bloginfo( 'pingback_url' ); ?>" />
<script src="/assets/jquery.js?body=1" type="text/javascript"></script>
<script src="/assets/jquery_ujs.js?body=1" type="text/javascript"></script>
<!--[if lt IE 9]>
<script src="<?php echo get_template_directory_uri(); ?>/js/html5.js" type="text/javascript"></script>
<![endif]-->
<?php
	/* We add some JavaScript to pages with the comment form
	 * to support sites with threaded comments (when in use).
	 */
	if ( is_singular() && get_option( 'thread_comments' ) )
		wp_enqueue_script( 'comment-reply' );

	/* Always have wp_head() just before the closing </head>
	 * tag of your theme, or you will break many plugins, which
	 * generally use this hook to add elements to <head> such
	 * as styles, scripts, and meta tags.
	 */
	wp_head();
?>
<script type="text/javascript">
jQuery(function() {
  jQuery('#browse input').hide();
  jQuery('#browse select').bind('change', function() {
   jQuery(this).closest('form').submit();
  });
  // jQuery(".categories select").bind("change", function() {
//    jQuery(this).closest("form").submit();
//   });
//   jQuery(".collections select").bind("change", function() {
//    jQuery(this).closest("form").submit();
//   });

  // jQuery('.user_util_links').load('/user_util_links');
});
</script>
</head>

<body <?php body_class(); ?>>
<div id="main-container" class="hfeed container">
  <div id="header" class="row">
            <div class="span12">
              <!-- Openvault Logo and login -->
  <div class="row" id="header_top">
    <div class="span6">
  	<a href="/">
      	<div id="ov-logo-home">
  				OpenVault
  		</div>
  	</a>
    </div>
    <div class="span6 pull-right action_links">
      &nbsp;
    </div>
  </div>
  <!-- Logo and login -->
  <!-- MLA Logo and search bar -->
  <div class="row">
    <div class="span3">
      <div id="mla-logo">Media Library and Archives</div>
    </div>
      <div class="span9">
        <div id="search-bar">
    <form accept-charset="UTF-8" action="/catalog" class="search-query-form form-inline clearfix" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="✓"></div>
      <input name="slug" type="hidden" value="test-collection-1"> 

        <div class="pull-left">
          <label for="search_field" class="hide-text">Search in</label>
          <span class="hide-text">for</span>
        </div>
         <div class="input-append pull-left">
          <label for="q" class="hide-text">Searh Archive</label>
           <input class="search_q q" id="q" name="q" placeholder="Searh Archive" type="text">
          <button type="submit" class="search-btn" id="search">
            <i class="icon-search"></i>
          </button>
         </div>
  </form>	<div id="browse">
  		<label>Browse: </label>
      <!-- Need to add dynamic categories and collections -->
      <form accept-charset="UTF-8" action="/catalog" class="categories" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="✓" style="display: none;"></div>
        <select id="f_merlot_s" name="f[merlot_s][]"><option value="">Categories</option>
  <optgroup label="Categories"><option value="category-1">Category 1</option></optgroup></select>
        <input name="commit" type="submit" value="Browse Category" style="display: none;">
  </form>    
      <form accept-charset="UTF-8" action="/catalog" class="collections" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="✓" style="display: none;"></div>
        <select id="id_" name="id[]"><option value="">Collections and Series</option>
  <optgroup label="Collections and Series"><option value="collection-1">Collection 1</option>
  <option value="collection-2">Collection 2</option></optgroup><optgroup label="Series"><option value="series-1">Series 1</option>
  <option value="series-2">Series 2</option></optgroup></select>
        <input name="commit" type="submit" value="Browse collection" style="display: none;">
  </form>	</div>

  </div>

      </div>
  </div>
            </div>
  				</div>
  <!-- <header id="branding" role="banner">
      <hgroup>
        <h1 id="site-title"><span><a href="/" title="<?php echo esc_attr( get_bloginfo( 'name', 'display' ) ); ?>" rel="home"><?php bloginfo( 'name' ); ?></a></span></h1>
        <h2 id="site-description"><?php bloginfo( 'description' ); ?></h2>
      </hgroup>
<div id="search-bar">
  <form accept-charset="UTF-8" action="/catalog" class="search-query-form form-inline clearfix" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="✓"></div>
      <input name="slug" type="hidden" value="test-collection-1"> 

        <div class="pull-left">
          <label for="search_field" class="hide-text">Search in</label>
          <span class="hide-text">for</span>
        </div>
         <div class="input-append pull-left">
          <label for="q" class="hide-text">Searh Archive</label>
           <input class="search_q q" id="q" name="q" placeholder="Searh Archive" type="text">
          <button type="submit" class="search-btn" id="search">
            <i class="icon-search"></i>
          </button>
         </div>
  </form>

<div id="browse">
  <h2 class="search">Browse Archive</h2>
    <form accept-charset="UTF-8" action="/catalog" class="categories" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="✓" style="display: none; "></div>
      <select id="f_merlot_s" name="f[merlot_s][]"><option value="">Categories</option>
<optgroup label="Categories"><option value="Arts">Arts</option>
<option value="Business">Business</option>
<option value="Education">Education</option>
<option value="Humanities">Humanities</option>
<option value="Massachusetts">Massachusetts</option>
<option value="Science &amp; Technology">Science &amp; Technology</option>
<option value="Social Sciences">Social Sciences</option></optgroup></select>
      <input name="commit" type="submit" value="Browse Category" style="display:none;" >
</form>
    <form accept-charset="UTF-8" action="/catalog" class="collections" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="✓" style="display: none; "></div>
      <select id="id_" name="id[]"><option value="">Collections and Series</option>
<optgroup label="Collections"><option value="march-march-on-washington">March on Washington</option>
<option value="prpe-press-and-the-people">Press and the People</option>
<option value="sbro-say-brother">Say Brother</option>
<option value="ntw-the-new-television-workshop">The New Television Workshop</option>
<option value="tocn-the-ten-o-clock-news">The Ten O'Clock News</option>
<option value="vietnam-the-vietnam-collection">The Vietnam Collection</option>
<option value="wpna-war-and-peace-in-the-nuclear-age">War and Peace in the Nuclear Age</option></optgroup><optgroup label="Series"><option value="ntw-aliv-alive-from-off-center">Alive From Off Center</option>
<option value="amex-american-experience">American Experience</option>
<option value="ntw-plah-american-playhouse">American Playhouse</option>
<option value="ntw-arsc-artist-s-showcase">Artist’s Showcase</option>
<option value="tocn-cwky-compass-weekly-the">Compass Weekly, The</option>
<option value="ntw-catf-contemporary-art-fund-cat">Contemporary Art Fund (CAT)</option>
<option value="ntw-danc-dance-for-camera">Dance for Camera</option>
<option value="ntw-darc-design-archiving-project">Design Archiving Project</option>
<option value="tocn-evco-evening-compass-the">Evening Compass, The</option>
<option value="ntw-frar-frames-of-reference">Frames of Reference</option>
<option value="ntw-miwk-music-image-workshop">Music Image Workshop</option>
<option value="ntw-ntvw-new-television-workshop">New Television Workshop</option>
<option value="ntw-poeb-poetry-breaks">Poetry Breaks</option>
<option value="ntw-ratv-rockefeller-artists-in-television">Rockefeller Artists in Television</option>
<option value="sbro-sayb-say-brother">Say Brother</option>
<option value="ntw-sond-soundings">Soundings</option>
<option value="ntw-twca-twentieth-century-artists">Twentieth Century Artists</option>
<option value="ntw-visi-visions">Visions</option></optgroup></select>
      <input name="commit" type="submit" value="Browse collection" style="display:none;">
</form></div>
</div>
  </header>
    -->
	<div id="main" class="row">
