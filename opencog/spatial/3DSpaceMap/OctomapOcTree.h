/*
 * OctoMap - An Efficient Probabilistic 3D Mapping Framework Based on Octrees
 * http://octomap.github.com/
 *
 * Copyright (c) 2009-2013, K.M. Wurm and A. Hornung, University of Freiburg
 * All rights reserved.
 * License: New BSD
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the University of Freiburg nor the names of its
 *       contributors may be used to endorse or promote products derived from
 *       this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef OPENCOG_OCTOMAP_OCTREE_H
#define OPENCOG_OCTOMAP_OCTREE_H

// OctomapOcTree
// It's a class inheriting the OcTree in octomap
// We just add the block handle in each node and add some helper functions
// Note: When there's no OctreeNode in given position,
// it means that we don't know anything about that position.
// When we can get a OctreeNode, it means that we have known the block.
// And we judge if one block is existing by
// checking its occupancy log odds are larger than the occupancy log odds threshold.
// If the occupancy log odds of node < thres, we regard it as freespace
// else, It's a block in the space.

#include <map>
#include <vector>
#include <octomap/OcTreeNode.h>
#include <octomap/OccupancyOcTreeBase.h>
#include <opencog/atomspace/Handle.h>
#include "Block3DMapUtil.h"

using namespace std;
using namespace octomap;

namespace opencog
{
    namespace spatial
    {

        class OctomapOcTreeNode : public OcTreeNode
        {
        public:
            OctomapOcTreeNode() : OcTreeNode(), mblockHandle(Handle::UNDEFINED){}
            OctomapOcTreeNode(const OctomapOcTreeNode& rhs);
            ~OctomapOcTreeNode(){}
            OctomapOcTreeNode& operator=(const OctomapOcTreeNode& rhs);
            // children
            inline OctomapOcTreeNode* getChild(unsigned int i)
            {
                return static_cast<OctomapOcTreeNode*> (OcTreeNode::getChild(i));
            }
            inline const OctomapOcTreeNode* getChild(unsigned int i) const
            {
                return static_cast<const OctomapOcTreeNode*> (OcTreeNode::getChild(i));
            }

            bool createChild(unsigned int i)
            {
                if (children == NULL) {
                    allocChildren();
                }
                children[i] = new OctomapOcTreeNode();
                return true;
            }

            void setBlock(const Handle& block)
            {
                mblockHandle = block;
            }

            Handle getBlock() const
            {
                return mblockHandle;
            }

            void cloneNodeRecur(const OctomapOcTreeNode& rhs);
        private:
            Handle mblockHandle;
        };

        // tree definition
        class OctomapOcTree : public OccupancyOcTreeBase <OctomapOcTreeNode> {

        public:
            // Default constructor, sets resolution of leafs
            OctomapOcTree(const std::string& mapName, const double resolution);
            ~OctomapOcTree(){}

            // virtual constructor: creates a new object of same type
            // (Covariant return type requires an up-to-date compiler)
            OctomapOcTree* create() const {return new OctomapOcTree(resolution); }

            std::string getTreeType() const {return "OctomapOcTree";}
            // deep clone this octree3DMapManager and return the new instance
            OctomapOcTree* clone() const;

            inline string getMapName() const {return mMapName;}
            inline float getAgentHeight() const {return mAgentHeight;}
            void setAgentHeight(float _height){ mAgentHeight = _height;}

            inline int getTotalUnitBlockNum() const {return mTotalUnitBlockNum;}

            //binary add/remove operation
            void addSolidUnitBlock(const Handle& block, BlockVector pos);
            void removeSolidUnitBlock(const Handle blockHandle);
            //Note that if you want to add/remove block with probability,
            //You should use setUnitBlock to control the occupancy probability.
            //the updateLogOddsOccupancy will be added on the log odds occupancy of block to in/decrease the occupancy
            //probabilistic set occupancy, e.g. new occupied log
            void setUnitBlock(const Handle& block, BlockVector pos, float updateLogOddsOccupancy);

            // binary
            BlockVector getBlockLocation(const Handle& block) const;
            // probabilistic
            BlockVector getBlockLocation(const Handle& block, float logOddsOccupancyThreshold) const;


            // set node block handle at given key or coordinate. Replaces previous block handle.
            OctomapOcTreeNode* setNodeBlock(const double& x, const double& y,const double& z, const Handle& block);
            OctomapOcTreeNode* setNodeBlock(const point3d& pos, const Handle& block);

            //  check if the block is out of octree's max size
            bool checkIsOutOfRange(const BlockVector& pos) const;

            //  use occ_prob_thres_log(see octomap doc) as threshold
            Handle getBlock(const BlockVector& pos) const;
            //  get block in pos. If occupancy(log odds) larger than threshold
            //  It will return the block (including undefined handle) in pos;
            //  If smaller than threshold, it'll return Handle::UNDEFINED
            //  default threshold is the prob_hit_log which is the default
            //  octomap log odds threshold.
            Handle getBlock(const BlockVector& pos, const float logOddsOccupancyThreshold) const;
            //  use occ_prob_thres_log(see octomap doc) as threshold
            bool checkBlockInPos(const Handle& block, const BlockVector& pos) const;
            //  check the block is in the position,
            //  Noth that even there's a block in that pos,
            //  if the handle is not equal it still return false.
            bool checkBlockInPos(const Handle& block, const BlockVector& pos, const float logOddsOccupancyThreshold) const;


            // functions for save/load map in persist/, but haven't implemented yet. Keep it to make code compiled.
            void save(FILE* fp ){};
            void load(FILE* fp ){};
            static std::string toString(const OctomapOcTree& map ){return string("");}
            static OctomapOcTree* fromString(const std::string& map ){return NULL;}

        protected:

            /**
             * Static member object which ensures that this OcTree's prototype
             * ends up in the classIDMapping only once
             */

        OctomapOcTree(double resolution): OccupancyOcTreeBase<OctomapOcTreeNode>(resolution){}
            class StaticMemberInitializer{
            public:
                StaticMemberInitializer() {
                    OctomapOcTree* tree = new OctomapOcTree(0.1);
                    AbstractOcTree::registerTreeType(tree);
                }
            };
            // static member to ensure static initialization (only once)
            static StaticMemberInitializer octomapOcTreeMemberInit;

            std::string mMapName;
            float mAgentHeight;
            int mTotalUnitBlockNum;

            // We keep the map for quick search position.
            // Memory consuming: 50k blocks take about 10M RAM for one map
            // Time consuming: 2e-5 sec for 10k blocks; if using bindlink to get position cost 2e-3 sec
            map<Handle, BlockVector> mAllUnitAtomsToBlocksMap;

            // this constructor is only used for clone
            OctomapOcTree(const OctomapOcTree&);
        };

    } // end namespace
}
#endif
