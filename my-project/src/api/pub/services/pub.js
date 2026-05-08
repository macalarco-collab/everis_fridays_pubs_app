'use strict';

const pub = require('../controllers/pub');

/**
 * pub service
 */

const { createCoreService } = require('@strapi/strapi').factories;
module.exports = createCoreService('api::pub.pub', ({ strapi }) => ({
    async getAffordablePubs(maxPrice){
    const allPubs= await strapi.entityService.findMany('api::pub.pub', {populate: '*'});
    const affordablePubs=[];
    for (const pub of allPubs){

        if(pub.avgPrice<=maxPrice){
            affordablePubs.push(pub);}}
        
        return affordablePubs;
    }
}
));