# 1DOF ROBOT LOCALIZATION IN A CIRCULAR HALLWAY USING PARTICLE FILTER

"""
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%   Please DO NOT change the functions before line 218.   %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"""
 
import numpy as np
import matplotlib.pyplot as plt
import scipy.stats
import scipy.io
#from math import *
import random


class SimulationParameters(object):
	def __init__(self, frame_mat_path='animation.mat'):
		# Simulation frames (332 RGB images)
		self.frames = scipy.io.loadmat(frame_mat_path)['frame']
		self.frames = [self.frames[0,i][0] for i in range(self.frames.shape[1])]

		# Set seed for reproduction
		np.random.seed(12)

		self.circular_hallway = True    # True: Yes; False: No.
		self.plot_animation = True      # True: Plot the animation;
		                                # False: Do not plot (speed up the simulation).
		self.n_steps = 100              # Number of steps of the algorithm.
		self.domain = 849               # Domain size (in centimeters).
		self.x_true_0 = np.array([ \
		    np.mod(np.abs(np.ceil(self.domain * np.random.randn())), self.domain), 20 \
		])                              # Initial location and velocity of the robot.
		self.num_particles = 100        # Number of particles.
		self.wk_stdev = 1               # Standard deviation of the noise used
		                                #   in acceleration to simulate the robot movement.
		self.door_locations = [222, 326, 611]
		                                # Position of the doors (in centimetres).
		                                # This is the map definition.
		self.door_stdev = 90/4          # Wide of the door. +-2sigma of the door
		                                #   observation is assumend to be 90 cm.
		self.odometry_stdev = 2         # Odometry uncertainty. Standard deviation
		                                #   of a Gaussian pdf (in centimetres).
		self.T = 1                      # Simulation sample time
		return

class Simulator(object):
	def __init__(self):
		self.param = SimulationParameters()
		if self.param.plot_animation:
			self.fig, self.axs = plt.subplots(
				7, 1,
				num='Simulation',
				figsize=(5, 8),
				gridspec_kw={'height_ratios': [1]*6+[3]},
				constrained_layout=True,
			)
			self.vis_robot = self.axs[-1].imshow(np.ones((180, 849, 3), np.uint8) * 255)
			self.axs[-1].yaxis.set_visible(False)
			self.axs[-1].set_xlabel(r'$x$')
			self.axs[-1].xaxis.set_label_coords(1.02, 0)
		return

	def simulate(self):

		x_true_k = self.param.x_true_0
		if self.param.plot_animation:
			locations = np.arange(0, self.param.domain+1)
			measurement = self.getMeasurementModel(locations)
			self.drawMeasurement(0, r'Measurement $P(z_k=1|x_k=x)$', locations, measurement)

		# Initial robot belief is generated from the uniform distribution
		particles = np.random.uniform(0, self.param.domain, self.param.num_particles)

		for k in range(self.param.n_steps):

			# simulates the robot movement
			x_true_old = x_true_k
			x_true_k = self.simulateRobot(x_true_k)

			# robot step (>0 left, <0 right)
			uk = self.getOdometry(x_true_k, x_true_old)

			# zk = True when a door has sensed
			zk = self.getSensorState(x_true_k, x_true_old)

			print('Step %d, zk=%d, uk=%.2lf' % (k+1, zk, uk))
			if self.param.plot_animation:
				self.drawRobot(x_true_k, k+1, zk, uk)

			# Particle filter to localize the robot
			particles = self.particleFilter(particles, uk, zk)

			if self.param.plot_animation:
				plt.draw()
				plt.pause(0.01)

		return

	def simulateRobot(self, x_true_k):
		# Simulate how the robot moves. We will need to update the robot
		#   position here taking into account the noise in acceleration
		wk = np.random.randn() * self.param.wk_stdev
		x_true_k_new = np.array([
			x_true_k[0] + x_true_k[1] * self.param.T + 0.5 * wk * self.param.T ** 2, \
			x_true_k[1] + wk * self.param.T \
		])
		self.odometry_delta = 0
		if self.param.circular_hallway:
			# The hallway is assumed to be circular
			if x_true_k_new[0] > self.param.domain:
				self.odometry_delta = self.param.domain
			if x_true_k_new[0] < 0:
				self.odometry_delta = -self.param.domain
			x_true_k_new[0] = np.mod(x_true_k_new[0], self.param.domain)
		else:
			# The hallway is assumed to be linear
			if x_true_k_new[0] > self.param.domain:
				x_true_k_new[0] = self.param.domain - np.mod(x_true_k_new[0], self.param.domain)
				x_true_k_new[1] *= -1 # change direction of motion
			elif x_true_k_new[0] < 0:
				x_true_k_new[0] *= -1
				x_true_k_new[1] *= -1 # change direction of motion
			else:
				pass
		return x_true_k_new

	def drawRobot(self, x_true_k, k, zk, uk):
		self.axs[-1].set_title(r'Visualization of GT / $k=%d, z_k=%d, u_k=%.2f$' % (k, zk, uk))
		idx = int(np.floor(x_true_k[0] / self.param.domain * len(self.param.frames)))
		self.vis_robot.set_data(self.param.frames[idx])
		return

	def drawMeasurement(self, idx, title, locations, measurement):
		self.axs[idx].clear()
		self.axs[idx].set_title(title)
		self.axs[idx].plot(locations, measurement, '-')
		self.axs[idx].set_xlim(0, self.param.domain)
		self.axs[idx].set_xlabel(r'$x$')
		self.axs[idx].xaxis.set_label_coords(1.02, 0)
		self.axs[idx].set_ylim(0, 1.1)
		return

	def drawParticles(self, idx, title, particles, weights=None):
		self.axs[idx].clear()
		self.axs[idx].set_title(title)
		if weights is None:
			self.axs[idx].vlines(particles, 0.1, 0.9, linewidths=0.1)
			self.axs[idx].set_ylim(0, 1)
		else:
			self.axs[idx].vlines(particles, 0.6-weights/2, 0.6+weights/2, linewidths=0.1)
			self.axs[idx].set_ylim(0, 1.2)
		self.axs[idx].set_xlim(0, self.param.domain)
		self.axs[idx].set_xlabel(r'$x$')
		self.axs[idx].xaxis.set_label_coords(1.02, 0)
		self.axs[idx].yaxis.set_visible(False)
		return

	def drawParticleHist(self, idx, title, particles):
		self.axs[idx].clear()
		self.axs[idx].set_title(title)
		self.axs[idx].hist(particles, bins=85, range=(0,self.param.domain), density=True)
		self.axs[idx].set_xlim(0, self.param.domain)
		self.axs[idx].set_xlabel(r'$x$')
		self.axs[idx].xaxis.set_label_coords(1.02, 0)
		self.axs[idx].set_ylim(0, 0.06)
		return

	def getOdometry(self, x_true_k, x_true_k_old):
		# Simulate the odometry measurement including the noise
		delta = x_true_k[0] - x_true_k_old[0] + self.param.odometry_stdev * np.random.randn()
		if self.param.circular_hallway:
			delta += self.odometry_delta
			uk = np.mod(np.abs(delta), self.param.domain) * np.sign(delta)
		else:
			uk = delta
		return uk

	def getSensorStateBACKUP(self, x_true_k, x_true_k_old):
		# Simulate the detection of doors by the robot sensor
		sensor = False
		for door_location in self.param.door_locations:
			cond_1 = np.abs(x_true_k[0] - x_true_k_old[0]) < (self.param.door_stdev * 8)
			cond_2 = x_true_k[0] >= door_location and door_location >= x_true_k_old[0]
			cond_3 = x_true_k[0] <= door_location and door_location <= x_true_k_old[0]
			if cond_1 and (cond_2 or cond_3):
				sensor = True
				break
		return sensor

	def getSensorState(self, x_true_k, x_true_k_old):
		# Simulate the detection of doors by the robot sensor
		p_zk1_given_x = self.getMeasurementModel(x_true_k[0])
		sensor = np.random.rand() <= p_zk1_given_x
		return sensor

	def particleFilter(self, particles, uk, zk):
		# Apply the particle filter algorithm

		# Particle Motion
		prior_particles = self.moveParticles(particles, uk)

		# Measurement
		particle_weights = self.measureParticles(prior_particles, zk)

		# Resampling
		updated_particles = self.resampleParticles(prior_particles, particle_weights)

		# Plot the particles for the animation
		if self.param.plot_animation:
			self.drawParticles(1, r'Last Particles $P(x_{k-1}|z_{1:k-1})$', particles)
			self.drawParticles(2, r'Prior Particles $P(x_k|z_{1:k-1})$', prior_particles)
			self.drawParticles(3, r'Particle Weights of Prior Particles', prior_particles, particle_weights)
			self.drawParticles(4, r'Posterior/Resampled Particles $P(x_k|z_{1:k})$', updated_particles)
			self.drawParticleHist(5, r'Posterior/Resampled Particles Histogram', updated_particles)

		return updated_particles

	"""
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%   COMPLETE THESE FUNCTIONS   %%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	"""

	# 1. Measurement model P(zk=1|xk)
	def getMeasurementModel(self, locations):
		"""
		COMPLETE THIS FUNCTION

		Tips:
			* This function should compute the probability of the sensor 
			  detecting a door given the locations.

			* The variable door_x (x=1,2,3) below represents the probability
			  of the sensor successfully detecting the specific door x,
			  given the locations.

			* The sensor outputs a positive signal when it successfully
			  detects AT LEAST one door.

			* P(zk=1|xk) = 1 - P(zk=0|xk) = ...
		"""

		pdf_max = scipy.stats.norm(0, self.param.door_stdev).pdf(0)
		door_1 = scipy.stats.norm(self.param.door_locations[0], self.param.door_stdev).pdf(locations) / pdf_max
		door_2 = scipy.stats.norm(self.param.door_locations[1], self.param.door_stdev).pdf(locations) / pdf_max
		door_3 = scipy.stats.norm(self.param.door_locations[2], self.param.door_stdev).pdf(locations) / pdf_max

		# TODO: Change this value for the correct one

		# measurement = door_1 + door_2 + door_3

		measurement = 1.0 - (1.0 - door_1)*(1.0 - door_2)*(1.0 - door_3)

		return measurement

	# 2. Motion
	def moveParticles(self, particles, uk):
		"""
		COMPLETE THIS FUNCTION
		
		Tips:
			* Each particle has to evolve independently, so you are supposed
			  to add some noise (possibly using a normal distribution with
			  zero mean and 'self.param.odometry_stdev' std).

			* Use np.mod() to handle circular halls (when
			  self.param.circular_hallway is True).
		"""

		# TODO: Change this value for the correct one


		# noise = np.random.normal(0, self.param.odometry_stdev, self.param.num_particles)

		# prior_particles = particles + uk + noise


		prior_particles = []

		for i in range(self.param.num_particles):
			prior_particles.append(particles[i] + uk + self.param.odometry_stdev * np.random.randn())


		if self.param.circular_hallway:
			prior_particles = np.mod(prior_particles, self.param.domain)


		return prior_particles




	# 3. Measurement of Prior Particles
	def measureParticles(self, prior_particles, zk):
		"""
		COMPLETE THIS FUNCTION
		
		Tips:
			* The weight has the following property, wk ∝ P(xk|zk) ∝ P(zk|xk).
		
			* Use 'self.getMeasurementModel()'' to help tp compute the result.

			* if zk=0, you may use uniform weights or invert the weights,
			  i.e., P(zk=0|xk) = 1 - P(zk=1|xk).

			* You do not have to normalize the weights because
			  it will be anyway normalized in resampling part.
		"""

		# TODO: Change this value for the correct one
		particle_weights = self.getMeasurementModel(prior_particles)

		if zk == 0:
			particle_weights = 1 - particle_weights

		return particle_weights



	# 4. Resampling
	def resampleParticles(self, prior_particles, particle_weights):
		"""
		COMPLETE THIS FUNCTION
		
		Tips:
			* IMPORTANT NOTE: It is not allowed to use any built-in
			  sampling functions.

			* You may use 'np.searchsorted()' function.
		"""

		# TODO: Change this value for the correct one

		particle_weights = particle_weights/np.sum(particle_weights)

		resampled_particles = []

		resampling_wheel = True
		low_variance_sampling = False


		if resampling_wheel:

			index = int(random.random() * self.param.num_particles)
			beta = 0.0
			mw = np.max(particle_weights)

			for i in range(self.param.num_particles):
				beta += random.random() * 2.0 * mw

				while beta > particle_weights[index]:
					beta -= particle_weights[index]
					index = np.mod((index + 1), self.param.num_particles)
					if index == 0:
						index = 1

				resampled_particles.append(prior_particles[index])


		if low_variance_sampling:
			r = random.random() * (1 / self.param.num_particles)
			w = particle_weights[0]
			i = 0

			for m in range(self.param.num_particles):
				U = r + (m - 1) * (1 / self.param.num_particles)
				while U > w:
					i += 1
					w = w + particle_weights[i]
				resampled_particles.append(prior_particles[i])


		return resampled_particles




if __name__ == '__main__':
	simulator = Simulator()
	simulator.simulate()
	print('End of simulation')




