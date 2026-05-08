'use strict';

const { filter } = require('../../../../config/middlewares');
const affordable = require('../routes/affordable');

/**
 * pub controller
 */

const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::pub.pub', ({ strapi }) => ({

    async find(ctx) {
        let result  = await strapi.entityService.findMany('api::pub.pub', {populate: '*'});
        return result
    },
    
    async affordable(ctx) {
        const maxPrice= ctx.query.maxPrice || 15;
        let result = await strapi.service('api::pub.pub').getAffordablePubs(maxPrice);
        return result;
    }

    }
        
));