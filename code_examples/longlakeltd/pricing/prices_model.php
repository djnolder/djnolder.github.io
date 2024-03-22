<?php
/**
 * This model will help keep an instance of the prices table available any time
 * price it called. This should help drastically speed up pages with mutliple 
 * price shortcode calls.
 **/
namespace lll_admin;

class prices_model {
	private static $instance = null;
	public $by_neighborhood;
	public $by_plan;

	public static function getInstance() {
		if (self::$instance == null) {
			self::$instance = new static;
		}
		return self::$instance;
	}

	protected function __construct() {
		global $wpdb, $post;
		// we only want prices for plans and neighborhoods that are published
		$res = $wpdb->get_results( "SELECT pr.* FROM lll_prices AS pr
			LEFT JOIN lll_posts AS pn ON pn.post_title = pr.neighborhood 
			LEFT JOIN lll_posts AS pp ON pp.post_title = pr.plan
			WHERE pn.post_type = 'neighborhood'
			AND pn.post_status = 'publish'
			AND pp.post_type = 'plan'
			AND pp.post_status = 'publish'" );
		foreach ($res as $r) {
			if (!empty($r->price)) {
				$this->by_neighborhood[$r->neighborhood][$r->plan] = $r->price;
				$this->by_plan[$r->plan][$r->neighborhood] = $r->price;
			}
		}
	}

	public function get_neighborhood_price_range($neighborhood) {
		$prices = $this->by_neighborhood[$neighborhood];

		$price_low = $price_high = 0;
		foreach ($prices as $r) {
			if ($price_low > $r->price || $price_low == 0) {
				$price_low = $r->price;
			}
			if ($price_high < $r->price) {
				$price_high = $r->price;
			}
		}

		return '';
	}

	public function get_prices($neighborhood = null, $plan = null) {
		$prices = null;

		// if neighborhood doesn't exist in prices table (new neighborhoods), then return false before we throw a bunch of warnings
		if ($neighborhood != null && !isset($this->by_neighborhood[$neighborhood])) {
			return false;
		}

		// always return array, even for single price
		if ($neighborhood && $plan) {
			$price = $this->by_neighborhood[$neighborhood][$plan];
			return [$price];
		}elseif ($neighborhood) {
			if (isset($this->by_neighborhood[$neighborhood])) {
				$prices = $this->by_neighborhood[$neighborhood];
			}
		}elseif ($plan) {
			if (isset($this->by_plan[$plan])) {
				$prices = $this->by_plan[$plan];
			}
		}else {
			$prices = $this->by_neighborhood;
		}

		if (!is_array($prices)) {
			return false;
		}

		$price_low = $price_high = 0;
		foreach ($prices as $price) {
			if (is_array($price)) {
				foreach ($price as $p) {
					if ($price_low > $p || $price_low == 0) {
						$price_low = $p;
					}
					if ($price_high < $p) {
						$price_high = $p;
					}
				}
			}else {
				if ($price_low > $price || $price_low == 0) {
					$price_low = $price;
				}
				if ($price_high < $price) {
					$price_high = $price;
				}
			}
		}
		return [$price_low, $price_high];
	}

}