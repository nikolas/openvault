<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'ov_wp');

/** MySQL database username */
define('DB_USER', 'ov_dev');

/** MySQL database password */
define('DB_PASSWORD', 'ov_dev');

/** MySQL hostname */
define('DB_HOST', '127.0.0.1');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'SCO=& v>hV-c:!jTBOq@:X|f}FnhtRi>GpHPl$4[JTdQbg R(BQi7*3lWV/DQuwr');
define('SECURE_AUTH_KEY',  ';sr8mM63;;-N_4-2:3&YNR0*]J]&%r71Y<Wgks:PSiP6fy|e=GM+7YJW`f/bBi%A');
define('LOGGED_IN_KEY',    '/[Jg`LX7k#<(B9!hCR3sk$Ilm (yF;b}nVdG[l+x bLQ!vxVudFpCEb+L2fy yC4');
define('NONCE_KEY',        '>3//Ny)l GOADB`RO+ltuo-kwJt(MQ#G8#/8vg/A`#]kV,gPl*^0Up#.(nCn4}2`');
define('AUTH_SALT',        'wr>(|f9dlpIT*.Nn<0_(keu5B=!EskDhX/x6?q<HVQ!zZe=l4yQQN;yjD4Z|6I>:');
define('SECURE_AUTH_SALT', '+m*^,S$}xk6DC%wIJS=%QJAZ~U0@L+XJthHF)cE*>J1xX0N?8AaoE@P^o=<dh*5b');
define('LOGGED_IN_SALT',   'Z*0k2RJqEc8mz#z_o6z|4D}N9Fuq4h2$#:i8-C]ggF)H(FvbS<U/a&2Mk6=.Lp^$');
define('NONCE_SALT',       '+U5`5[6Y)`~i:[-8Wh`o#aZ$IkT}K|(d0 }o|rna#E?D2{W%J/cuGobi<<r%Vfvx');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', '');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
