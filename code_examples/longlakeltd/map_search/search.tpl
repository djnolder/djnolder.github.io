<div id="lll_search">
	<div id="controls">
		<h3 class="title">Find Your Home</h3>
		<button type="button" id="edit_filters_button"><i class="fas fa-search"></i> Filters</button>
		<div class="current_filters">
		</div>
		<button type="button" id="clear_filters_button" class="search_button zoom_full_button">Clear</button>
	</div>
	<div class="row">
		<div id="results">
			<div class="results_handle fas fa-chevron-circle-right"></div>
			<div class="waiter"><div class="lds-roller"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div></div>
			<div class="results">
				{% if not data.inventory is empty %}
					<div class="sticky_section">
						<div class="title_inventory">Available Inventory</div>
						<h6 class="disclaimer">Pricing and specifications are subject to change at any time and without notice</h6>
					</div>
					<div id="inventory_noresult" class="no_results">Your current filters and map location have eliminated all results!</div>
					<div id="inventory_result_section" class="result_section">
						{% for id, idata in data.inventory %}
							<a href="{{idata.url}}" class="home_block" data-home="{{id}}" data-neighborhood="{{idata.neighborhood}}" data-price="{{idata.price}}" data-square_feet="{{idata.square_feet}}" data-stories="{{idata.stories}}" data-bedrooms="{{idata.bedrooms}}" data-bathrooms="{{idata.bathrooms}}">
								<div class="title">{{ idata.title }}</div>
								<div class="subtitle">in {{ data.neighborhood[idata.neighborhood].title }}</div>
								<div class="status">{{idata.status}}</div>
								<div class="image_wrapper">
									<img src="{{ idata.image }}" />
								</div>
								<div class="price">${{ idata.price | number_format(0, '.', ',') }}</div>
								<div class="details">
									<div><div>{{ idata.square_feet }}</div><div>SQ&nbsp;FT</div></div>
									<div><div>{{ idata.stories }}</div><div>Stories</div></div>
									<div><div>{{ idata.bedrooms }}</div><div>Beds</div></div>
									<div><div>{{ idata.bathrooms }}</div><div>Baths</div></div>
								</div>
							</a>
						{% endfor %}
					</div>
				{% endif %}
				<div class="sticky_section">
					<div class="title_plans">Build Your Dream Home</div>
					<h6 class="disclaimer">Pricing and specifications are subject to change at any time and without notice</h6>
				</div>
				<div id="plans_noresult" class="no_results">Your current filters and map location have eliminated all results!</div>
				<div id="plans_result_section" class="result_section">
					{% for pid, pdata in data.plan %}
						{% for nid, ndata in data.neighborhood %}
						{% set price = data.prices[pdata.title][ndata.title] %}
							{% if price %}
								<a href="{{pdata.url}}" class="home_block new_home" data-plan="{{pid}}" data-neighborhood="{{nid}}" data-price="{{price}}" data-square_feet="{{pdata.square_feet}}" data-stories="{{pdata.stories}}" data-bedrooms="{{pdata.bedrooms}}" data-bathrooms="{{pdata.bathrooms}}">
									<div class="title">{{ pdata.title }}</div>
									<div class="subtitle">in {{ ndata.title }}</div>
									<div class="status">New Construction</div>
									<div class="image_wrapper">
										<img src="{{ pdata.image }}" />
									</div>
									<div class="price">${{ price | number_format(0, '.', ',') }}</div>
									<div class="details">
										<div><div>{{ pdata.square_feet }}</div><div>SQ&nbsp;FT</div></div>
										<div><div>{{ pdata.stories }}</div><div>Stories</div></div>
										<div><div>{{ pdata.bedrooms }}</div><div>Beds</div></div>
										<div><div>{{ pdata.bathrooms }}</div><div>Baths</div></div>
									</div>
								</a>
							{% endif%}
						{% endfor %}
					{% endfor %}
				</div>
			</div>
		</div>
		<div id="map"></div>
	</div>
	<div id="lll_search_overlay">
		<div id="lll_search_filters_modal">
			<form id="lll_search_filters">
				<div class="modal_header">
					<h4 class="title">Filters</h4>
				</div>
				<div class="filter_fields">
					<fieldset id="area_field" data-abbr="Area">
						<label for="filter_area">Area</label>
						<div>
							<select name="Area" id="filter_area" class="filter" data-filter="area" data-comparison="==" data-hashkey="ar">
								<option value="">***</option>
								{% for area_id, area_name in data.areas %}
									<option value="{{area_id}}">{{area_name}}</option>
								{% endfor %}
							</select>
						</div>
					</fieldset>
					<fieldset id="neighborhood_field" data-abbr="Neighborhood">
						<label for="filter_neighborhood">Neighborhood</label>
						<div>
							<select name="Neighborhood" id="filter_neighborhood" class="filter"data-filter="neighborhood" data-comparison="==" data-hashkey="ne">
								<option value="">***</option>
								{% for nid, ndata in data.neighborhood %}
									<option value="{{nid}}">{{ndata.title}}</option>
								{% endfor %}
							</select>
						</div>
					</fieldset>
					<fieldset id="stories_field" data-abbr="Stories">
						<label for="filter_stories">Stories</label>
						<div>
							<select name="Stories" id="filter_stories" class="filter" data-filter="stories" data-comparison="==" data-hashkey="st">
								<option value="">***</option>
								<option value="1">1 Story</option>
								<option value="1.5">1.5 Story</option>
								<option value="2">2 Story</option>
								<option value="2.5">2.5 Story</option>
								<option value="3">3 Story</option>
							</select>
						</div>
					</fieldset>
					<fieldset id="beds_field" data-abbr="Beds">
						<label for="filter_min_bedrooms">Bedrooms</label>
						<div>
							<select name="Beds[min]" id="filter_min_bedrooms" class="filter" data-filter="bedrooms" data-comparison=">=" data-hashkey="ben">
								<option value="">No Min</option>
								{% for i in range(1, 9) %}
									<option value="{{i}}">{{i}}</option>
								{% endfor %}
							</select>
							<select name="Beds[max]" id="filter_max_bedrooms" class="filter" data-filter="bedrooms" data-comparison="<=" data-hashkey="bex">
								<option value="">No Max</option>
								{% for i in range(1, 9) %}
									<option value="{{i}}">{{i}}</option>
								{% endfor %}
							</select>
						</div>
					</fieldset>
					<fieldset id="baths_field" data-abbr="Baths">
						<label for="filter_min_bathrooms">Bathrooms</label>
						<div>
							<select name="Baths[min]" id="filter_min_bathrooms" class="filter" data-filter="bathrooms" data-comparison=">=" data-hashkey="ban">
								<option value="">No Min</option>
								{% for i in range(2, 18) %}
									<option value="{{i/2}}">{{i/2}}</option>
								{% endfor %}
							</select>
							<select name="Baths[max]" id="filter_max_bathrooms" class="filter" data-filter="bathrooms" data-comparison="<=" data-hashkey="bax">
								<option value="">No Max</option>
								{% for i in range(2, 18) %}
									<option value="{{i/2}}">{{i/2}}</option>
								{% endfor %}
							</select>
						</div>
					</fieldset>
					<fieldset id="sqft_field" data-abbr="SqFt">
						<label for="filter_min_square_feet">Square Feet</label>
						<div>
							<select name="SqFt[min]" id="filter_min_square_feet" class="filter" data-filter="square_feet" data-comparison=">=" data-hashkey="sqn">
								<option value="">No Min</option>
								{% for i in range(2, 9) %}
									<option value="{{i*500}}">{{i*500}}</option>
								{% endfor %}
							</select>
							<select name="SqFt[max]" id="filter_max_square_feet" class="filter" data-filter="square_feet" data-comparison="<=" data-hashkey="sqx">
								<option value="">No Max</option>
								{% for i in range(2, 9) %}
									<option value="{{i*500}}">{{i*500}}</option>
								{% endfor %}
							</select>
						</div>
					</fieldset>
					<fieldset id="price_field" data-abbr="Price">
						<label for="filter_min_square_feet">Price</label>
						<div>
							<select name="Price[min]" id="filter_min_price" class="filter" data-filter="price" data-comparison=">=" data-hashkey="prn">
								<option value="">No Min</option>
								{% for i in range(0, 12) %}
									{% set v = 100000 + i * 25000 %}
									<option value="{{v}}">${{ v / 1000 }}k</option>
								}
								{% endfor %}
							</select>
							<select name="Price[max]" id="filter_max_price" class="filter" data-filter="price" data-comparison="<=" data-hashkey="prx">
								<option value="">No Max</option>
								{% for i in range(0, 12) %}
									{% set v = 100000 + i * 25000 %}
									<option value="{{v}}">${{ v / 1000 }}k</option>
								{% endfor %}
							</select>
						</div>
					</fieldset>
				</div>
				<div class="modal_footer">
					<button id="close_filters_button" type="button">Cancel</button>
					<button id="submit_button" type="submit">Apply</button>
				</div>
			</form>
		</div>
	</div>
</div>
