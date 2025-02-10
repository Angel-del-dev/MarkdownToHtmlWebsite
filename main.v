module main

import veb
import os
import json
import markdown

pub struct App {
	veb.StaticHandler
	veb.Middleware[Context]
}

pub struct Context {
	veb.Context
}

pub struct RouteHandler {
pub mut:
	route string
}

pub struct ResponseHandler {
	pub mut:
		menu []string
		page string
}

pub fn (mut ctx Context) not_found() veb.Result {
	template := os.read_file('./html/index.html') or { '<h1>Could not find index</h1>' }
	return ctx.html(template)
}

@['/route';post]
pub fn (mut app App) route(mut ctx Context) veb.Result {
	mut route_handler := json.decode(RouteHandler, ctx.form['json']) or { RouteHandler{} }

	route_handler.route = os.abs_path('templates/'+route_handler.route)

	mut menu := []string{}
	mut page := ''

	mut dir_path := route_handler.route

	if os.is_file(route_handler.route) {
		if os.exists(route_handler.route) {
			page = os.read_file(route_handler.route) or { '<h1>Route not found</h1>' }
			mut tmp_route_splitted := route_handler.route.split('/')
			tmp_route_splitted.pop()
			dir_path = os.abs_path('templates/'+tmp_route_splitted.join('/'))
		}
	}

	if os.exists(dir_path) {
		menu = os.ls(dir_path) or { []string{} }
		if page == '' && os.exists(os.abs_path(dir_path)+'/dashboard.md') {
			page = os.read_file(os.abs_path(dir_path)+'/dashboard.md') or { '<h1>A default file does not exist for this route</h1>' }
		}
	}

	mut response := ResponseHandler{
		menu: menu
		page: markdown.to_html(page)
	}

	return ctx.json(response)
}

fn main() {
	mut app := &App{}
	app.handle_static('static', true)!
	veb.run[App, Context](mut app, 8080)
}