module main

import veb
import os
import json

pub struct App {
	veb.StaticHandler
	veb.Middleware[Context]
}

pub struct Context {
	veb.Context
}

pub struct RouteHandler {
	route string
}

pub fn (mut ctx Context) not_found() veb.Result {
	template := os.read_file('./html/index.html') or { '<h1>Could not find index</h1>' }
	return ctx.html(template)
}

@['/route';post]
pub fn (mut app App) route(mut ctx Context) veb.Result {
	route_handler := json.decode(RouteHandler, ctx.form['json']) or { RouteHandler{} }
	print(route_handler.route)
	return ctx.html('Hello from route')
}

fn main() {
	mut app := &App{}
	app.handle_static('static', true)!
	veb.run[App, Context](mut app, 8080)
}