package com.hello.quarkus.sidebyside.demo;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/api")
public class GreetingResource {

    @GET
    @Path("/hello")
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
        return "[quakus]: Hello !";
    }

    @GET
    @Path("/livecheck")
    @Produces(MediaType.TEXT_PLAIN)
    public String liveCheck() {
        return "OK";
    }

    @GET
    @Path("/healthcheck")
    @Produces(MediaType.TEXT_PLAIN)
    public String healthCheck() {
        return "OK";
    }


}